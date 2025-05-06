class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.12/Python-3.11.12.tgz"
  sha256 "379c9929a989a9d65a1f5d854e011f4872b142259f4fc0a8c4062d2815ed7fba"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2b7c4d7ee9c2f8b6ce40037744162a7d082ac85aaac788bfb84b75e22eecf950"
    sha256 cellar: :any, arm64_sonoma:  "a4365561edde1e9348922a82fbc241e153e48b54a273e5078d10024227f76f9c"
    sha256 cellar: :any, arm64_ventura: "06685a9c327490fb54c0fc7812f4b72bb4be58da4f088aa99d52aae2fbab4644"
    sha256 cellar: :any, sonoma:        "6a3f1fbd69a02dd0678b770ed15a2115961eaee3cd4e8f6e2281498eb074eb70"
    sha256 cellar: :any, ventura:       "d94e887af451811b87ec461c85f50606f29d8985d92dfc2719e6fc81467841df"
    sha256               arm64_linux:   "788c449cda242d125479d70279b280337af1056cf5c57685372756f2907ee7c8"
    sha256               x86_64_linux:  "bdfbc550557657b083c1e0f9a1f91d49b79a8563548f126ee1e8c8dbfa8cbcd5"
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
