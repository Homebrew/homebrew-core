class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.8/Python-3.12.8.tgz"
  sha256 "5978435c479a376648cb02854df3b892ace9ed7d32b1fead652712bee9d03a45"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6415dc76ffa9ef22ae7586872388d9aa0c838aefa238596b987a7eafa13e5a67"
    sha256 cellar: :any, arm64_sonoma:  "45efefd27db8bf1cc3794f73e2f0e83f60d17b3230df9966462379ce42291406"
    sha256 cellar: :any, arm64_ventura: "aa9694de6cf795293afbac8ece63a1cf4654543c634919a1a579dc74ffbabb49"
    sha256 cellar: :any, sonoma:        "4b49e542138844d71ca09249cab5050e3928ab22429e0e9b9e50a75af9412f5b"
    sha256 cellar: :any, ventura:       "86eaeb03ec3f3f43c62d43ec6a32457b57b81560812ebf4d0ec013ff5b36968f"
    sha256               x86_64_linux:  "1abf6619339d6c49a610b44741555f9d29346647d0e397d9c2df3ba65d71f91b"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
