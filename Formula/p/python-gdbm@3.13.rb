class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.9/Python-3.13.9.tgz"
  sha256 "c4c066af19c98fb7835d473bebd7e23be84f6e9874d47db9e39a68ee5d0ce35c"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07dde29f754d6a8a19c2e66b0b3611840b9c192f0c94bf4abd6e13904b01e874"
    sha256 cellar: :any, arm64_sequoia: "d935a57318702874da1c2d9e5a2ba0517242088b2bd11190f076197519699202"
    sha256 cellar: :any, arm64_sonoma:  "e61ffe279515ea69c625c5107377d5f5e077e8b951c80a373e48b2fc0dba37bf"
    sha256 cellar: :any, sonoma:        "2124224056904b88155916523c49778df001b9677291a8204b5aa48bd22d4cec"
    sha256               arm64_linux:   "721ef1ed0e9d199e190c5fcc6472a18a35feb6d90c2f5b3fb462331f2e63404d"
    sha256               x86_64_linux:  "bbb1fe6059430f4f778fae3fab0152c9ff47b06f5ca7335763c3e081e9934d68"
  end

  depends_on "gdbm"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~PYTHON
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    PYTHON
  end
end
