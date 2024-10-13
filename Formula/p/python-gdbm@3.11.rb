class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.10/Python-3.11.10.tgz"
  sha256 "92f2faf242681bfa406d53a51e17d42c5373affe23a130cd9697e132ef574706"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "69cbac9b6954ed3697c69085b74a3e2a26b19fbad299dd7f463551231fc900d6"
    sha256 cellar: :any, arm64_sonoma:   "e702b324e1516c17437cd2fe6d71a1f882da03ad6ba3370378a44bd349a19706"
    sha256 cellar: :any, arm64_ventura:  "44098fe25d1c31186275fe2e96f86092da83422e9e222dfdcbbbff30b368e610"
    sha256 cellar: :any, arm64_monterey: "04cc82afa2b45711ed0d041dc9784452b1df22d808559efdaf909435f53a1184"
    sha256 cellar: :any, sonoma:         "7cd5c4898592ef20f06d5344f33336b465bbd097baeb0b88b6deb6cebd370423"
    sha256 cellar: :any, ventura:        "edf3dad5a2a29f7bf6469f2f7c8b81f4f4516f0bbfa8c33134ae37ba4725781d"
    sha256 cellar: :any, monterey:       "fc3dfc63222daf8e36b266eae108ad934698c1d95200df9d80416135bfaff191"
    sha256               x86_64_linux:   "f90f71238d9d5a0a68e5d4305ec94d2f23287e0e2634ce6bd4509ed21f96052c"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
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
