class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.5/Python-3.11.5.tgz"
  sha256 "a12a0a013a30b846c786c010f2c19dd36b7298d888f7c4bd1581d90ce18b5e58"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d76bbeb515f9923b5a7c935e11e00a1391b0bf71e548176e5536b066261ff64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217ec8688e841270213f67d7390230ad69c5ebc6d0f1c071091041777fceb0fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6b6331f12a31de9e4681c8845d410e7bb1f1bd68224d4724ad4011a3d8d36f0"
    sha256 cellar: :any_skip_relocation, ventura:        "e3fa7ba0909a3d5f3a9be6570f49a0538af3d0abd3dde50cc0f65f7b99fd6809"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf89542521a28dfccd7259fdb68e5d9e75568ae9efea90dced8dc5b8d5d3add"
    sha256 cellar: :any_skip_relocation, big_sur:        "40e25d2c3ecc4d5ce8c8a613a37b0a167b4bf1fd403df8ba9b6229212f69f6f2"
    sha256                               x86_64_linux:   "1e74714aea8a50534f77fc8f74a1a01af0e637b88017d67b2f203bb30a8dcf2d"
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
