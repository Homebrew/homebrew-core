class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.12/Python-3.13.12.tgz"
  sha256 "12e7cb170ad2d1a69aee96a1cc7fc8de5b1e97a2bdac51683a3db016ec9a2996"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "94a14ebd8bfdb13bfcec2c7ea67145ea096c5239391fd5b812030464cedf9844"
    sha256 cellar: :any, arm64_sequoia: "5da7f563d28552466bf91cf81ee127cd8d5503b7ab2ceb69bcccb50a8987323d"
    sha256 cellar: :any, arm64_sonoma:  "ba693a0a9f60608d66b71d4c354090e2324d4afb8e07f13c59832bb8791f48fd"
    sha256 cellar: :any, sonoma:        "b225c19a5fee3958f5d34917f2fb2b6ac37b70a5588005bc34bae334b53e0e4e"
    sha256               arm64_linux:   "f0e7dbb71d4cd1cb458d9d0d5139bf883800563336a93bda7d1cf45a99870426"
    sha256               x86_64_linux:  "6d17e8581ede85593047e022630d84113511dafbb5a975f7d4f74856695499a5"
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
