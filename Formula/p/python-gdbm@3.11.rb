class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.16/Python-3.11.16.tgz"
  sha256 "6c0bd76ab0ec7d94ed400b1497f01ac6c7751c8822615ee0855a3eb2d893ea76"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3f4770b297554d1c56ecad45f3ab52c89e15c980542bfe49724d732971ea27cc"
    sha256 cellar: :any, arm64_sequoia: "03371e003c7743c2cf7eea1015c468daa6c2f3ea797dfe15ff790cbced5520a5"
    sha256 cellar: :any, arm64_sonoma:  "8df9c38a3b70c4e77e850468191f5eb97065ed01ee811b6a985c72b969e78b49"
    sha256 cellar: :any, sequoia:       "4491411ee065136c722506611c5624d22a6e37cff6ee32948854350d0e24261d"
    sha256 cellar: :any, sonoma:        "5b7b630703553f7f62b43803ef2c595b013717806bcc00860230de224ae54e57"
    sha256               arm64_linux:   "87b98b5412a45ee79ab384c2a91d0e6d0ed7bb97c935f01a9ecd4fa3338973fa"
    sha256               x86_64_linux:  "03fc1e9e9cdc07d7abb28e1e0b2b027b9dbbf64ed0aff95cbc9efb0b8288b973"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2027-11-01", because: :deprecated_upstream
  disable! date: "2028-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{formula_opt_include("gdbm")}"],
                          libraries=["gdbm"],
                          library_dirs=["#{formula_opt_lib("gdbm")}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
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
