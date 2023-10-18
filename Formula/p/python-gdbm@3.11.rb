class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.6/Python-3.11.6.tgz"
  sha256 "c049bf317e877cbf9fce8c3af902436774ecef5249a29d10984ca3a37f7f4736"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "141a5ad1ef7d2ab9eddecb05f8e636a38eebd21d92c3ce4365cf65b990720fa8"
    sha256 cellar: :any, arm64_ventura:  "59e51127d2fb4ccd9a8a815fb2b0500952da3e3b1c62f461894e21f457457f28"
    sha256 cellar: :any, arm64_monterey: "fc17b7519b0fa7cb9a838f21a76df83b42122543b7a079b066417be898ad4a7d"
    sha256 cellar: :any, sonoma:         "1214849bc7b644d3285585d40612aa5a0c0b270ae19be16251fe463bbefa70e9"
    sha256 cellar: :any, ventura:        "2038b04f76509fe4260d8eac6e2a2826e00d8426e15e141deaaf5a1e033aec1f"
    sha256 cellar: :any, monterey:       "441f21b20135496da9003bb1b4c6339b34a9eecb093082b14c408aa0ab38d4cc"
    sha256               x86_64_linux:   "5fc85ba7dbf17c49c4aafc72c623040bf4f510cb1738d5253656177bda0c95cf"
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
