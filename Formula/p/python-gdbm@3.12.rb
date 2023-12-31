class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz"
  sha256 "d01ec6a33bc10009b09c17da95cc2759af5a580a7316b3a446eb4190e13f97b2"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1d3184b449580bbfbf327a0c46556ebb35b2f964278cd4f52c48a6b50f9f5ea7"
    sha256 cellar: :any, arm64_ventura:  "ea7581e27d69226f01641af673a379366c37889d5802c3dfe4f736013ca8cec5"
    sha256 cellar: :any, arm64_monterey: "78ec0df8df3c1053f549397773d9fbf254e752629065c4607ddbb3a721a9b7c1"
    sha256 cellar: :any, sonoma:         "49991507fee647ed366403d1cb60e5bc5fe04bfa06a6afaeb0637cdfd73c99d3"
    sha256 cellar: :any, ventura:        "a66844d2427d32506757a9d3395f1de33fa6727dc77cfd283a1ce5835c3b21dc"
    sha256 cellar: :any, monterey:       "b9ebab31f09f074578bce3f20d23a70b7d8809c249f17863dcf7e65332615359"
    sha256               x86_64_linux:   "c6b272fdc968e43336dd37c98bf4e30559d8d338bc2dbe76abc8327b9ff289dd"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4b/d9/d0cf66484b7e28a9c42db7e3929caed46f8b80478cd8c9bd38b7be059150/setuptools-69.0.2.tar.gz"
    sha256 "735896e78a4742605974de002ac60562d286fa8051a7e2299445e8e8fbb01aa6"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resource("setuptools").stage do
      system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath), "."
    end

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
