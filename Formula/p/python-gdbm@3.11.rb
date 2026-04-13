class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.15/Python-3.11.15.tgz"
  sha256 "f4de1b10bd6c70cbb9fa1cd71fc5038b832747a74ee59d599c69ce4846defb50"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8ce1e0e7e89582c44620eaf96ede0cd00f5fcbf3618488ff79e859e0aec67411"
    sha256 cellar: :any, arm64_sequoia: "b88c1f6c34e8015f12650e843f113138edce7f99147dc27cc3b05050ecf34810"
    sha256 cellar: :any, arm64_sonoma:  "d9fcb84b21a90fabe130886504c41acb3da99ded5275a510e7cef78bf54687ab"
    sha256 cellar: :any, sonoma:        "34215ebd709302711a7609a7c9164a82d7fea96a8e8cfdec905d44a1067d4506"
    sha256               arm64_linux:   "0d2c0dd5aef81a49977d51d2f360edecc3f6cc24f86ac99626a83e43777b0dec"
    sha256               x86_64_linux:  "10625ce8d08009a18fca4da99409be7b5171a301131db5d4ac64607aac0fa7a7"
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
