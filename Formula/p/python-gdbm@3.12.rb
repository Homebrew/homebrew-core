class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz"
  sha256 "a6b9459f45a6ebbbc1af44f5762623fa355a0c87208ed417628b379d762dddb0"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0e9d8e27a4ef4ba1201642848e8755446036ab4ba78a9621c93de8025bbfda6a"
    sha256 cellar: :any, arm64_ventura:  "6e350a390742e1fbbfea4632c18bc77dd62c935c1f011c0e8b9fe3d41349b881"
    sha256 cellar: :any, arm64_monterey: "a217ccc97b574e2916747fd71b0a3cdd364439c0e880e9e037e84f90f6dc69df"
    sha256 cellar: :any, sonoma:         "1c571bcfa3e315c4fab8cd09180070163b5b82eabcc8f9dbc0b03e7fd30816b9"
    sha256 cellar: :any, ventura:        "993090be739bcc9b8b249f2ab20fcd57de536d0b04ddac44639806343bce6f1b"
    sha256 cellar: :any, monterey:       "33223f24b92271d0c9a4e09d69428483ded2b8cd078bfcc5540bf75382161d18"
    sha256               x86_64_linux:   "94d64581a33279210d24c794b06e4779f4fcdf516536b91da31cca8ff442d806"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
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
