class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.14/Python-3.11.14.tgz"
  sha256 "563d2a1b2a5ba5d5409b5ecd05a0e1bf9b028cf3e6a6f0c87a5dc8dc3f2d9182"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "77a0d87ce12ea5c7ada880e9b920ce774e7925d5d08b7d0d328b34d9d403bcf1"
    sha256 cellar: :any, arm64_sequoia: "f78d34a36e3f0c0a68a52bdd65f4ba15e55281d5250cbe7a888fb841015cfcf8"
    sha256 cellar: :any, arm64_sonoma:  "72dde9c046252b6fb30ed3b7cac5fa80a77cbc7d07d8554add636e75b5531019"
    sha256 cellar: :any, sonoma:        "bfe4be40a89acd2419a36feefc5a4da7eb638996d190bb2f9e2d0b88d3a6cbf0"
    sha256               arm64_linux:   "10ccef03b65856bae55760a4199c3e0820b1a85a73a96a88e78170a639cdac2b"
    sha256               x86_64_linux:  "7371952f40a62c0552c00adbc5455d30737d9319e040718fc913bf727e34d0bd"
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
