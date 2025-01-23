class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.11/Python-3.11.11.tgz"
  sha256 "883bddee3c92fcb91cf9c09c5343196953cbb9ced826213545849693970868ed"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2a65a2d5291bd8004927681de2d40b5c808dc59b676434905bdc721e33eb07d7"
    sha256 cellar: :any, arm64_sonoma:  "50dcb7d0f00f696f5ce121232a489cf8e9846a25396172633c292de3ffbfcac0"
    sha256 cellar: :any, arm64_ventura: "a54e95c6f4f0af716022af4ed36c8eb0e694d63c84c597d48de9b3071d8030a8"
    sha256 cellar: :any, sonoma:        "1e5208d7cadccbe5bce97f85a656abd6a4da6547bc9fa03b8ea6c2e943e7e0b0"
    sha256 cellar: :any, ventura:       "3406b9a2d5249180456d792d055e44bfcc242dd79e98ef21dd8ade6dbfd6fe79"
    sha256               x86_64_linux:  "9185fe89d9dc446e83650b27e4d7a8f3f6622a39e8ab5378198ac56ce7516e5b"
  end

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
                          include_dirs=["#{Formula["gdbm"].opt_include}"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
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
