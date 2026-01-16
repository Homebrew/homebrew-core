class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz"
  sha256 "c609e078adab90e2c6bacb6afafacd5eaf60cd94cf670f1e159565725fcd448d"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9e0c53658d56a4ed0ede5a7243115d6a4a87ae3246768f33e54c323b6769ae8"
    sha256 cellar: :any, arm64_sequoia: "92dc43ea83a169cb46c2317349d65c497db6b23e97d68e45411274ab0b06469a"
    sha256 cellar: :any, arm64_sonoma:  "d1074eb4f51ad239bb507e40cf2e25fa9a78afb10e514021dfeadeca71bc3bb1"
    sha256 cellar: :any, sonoma:        "9006f17ec210057e20314cbcdb68d1356dd89cc4ff752c6723cb3fe40b30c484"
    sha256               arm64_linux:   "2a0823bc6717cde9325b47ae7892b9872e9f2b9fb631c38558331d32e38fbfb4"
    sha256               x86_64_linux:  "b16fcc2939b48dfea45c684f8efb27e9cf183739c88ee518cd2c368f453bab7a"
  end

  depends_on "gdbm"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
