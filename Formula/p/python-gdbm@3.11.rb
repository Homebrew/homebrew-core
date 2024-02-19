class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.7/Python-3.11.7.tgz"
  sha256 "068c05f82262e57641bd93458dfa883128858f5f4997aad7a36fd25b13b29209"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "fdb3f411a6f623db75cd29e377be87d1c631414f3ba9b2b4f5e3c0864f41b6c9"
    sha256 cellar: :any, arm64_ventura:  "1591659117bd24dccd47b40fd8ec974db53beae1ac860d523c4f93bfe4b523e5"
    sha256 cellar: :any, arm64_monterey: "c294f5956da6ddaec963decefac9ec646a82b2b3d5364232ddbefaab6b984ab4"
    sha256 cellar: :any, sonoma:         "c106e7702ed5088ef8490a723735f171898eee452459ff8708a8f0fd4d4a33f0"
    sha256 cellar: :any, ventura:        "b1798bbe4fa4ef462fffa4fdf220f50ead9049ff972ed4c2f34d500c7cac6c94"
    sha256 cellar: :any, monterey:       "4c7ab6863f7505bdbbc77bcba291093fd6d603750103c269375048f4239e9fb4"
    sha256               x86_64_linux:   "56dbe9cfbf63d78330475d26c7e40a407434d76bd49de3897bd51b970b7af921"
  end

  depends_on "gdbm"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~EOS
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
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~EOS
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    EOS
  end
end
