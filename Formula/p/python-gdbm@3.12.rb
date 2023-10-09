class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz"
  sha256 "51412956d24a1ef7c97f1cb5f70e185c13e3de1f50d131c0aac6338080687afb"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9a1f0b964794486c299c9d64f69e76e08d826009d451e1651e2a74a68f46ed78"
    sha256 cellar: :any, arm64_ventura:  "eeb870ac691c7bed08fd192fb232d2394b5530d112c90a03be77986c20d04339"
    sha256 cellar: :any, arm64_monterey: "534e52055ee5abf1359d3bd3466558913ca5d72c8e4739396f1d897464168113"
    sha256 cellar: :any, sonoma:         "58460f812979ac5b3dabf25c85ad4b5df00b95e7e9b6871b03143e5732ba473c"
    sha256 cellar: :any, ventura:        "044939b1213c668bd3e50e641b03366d57923b36cb00b351190c447f5ba1ea71"
    sha256 cellar: :any, monterey:       "eee819c21f41327961f46398895835691fb7c3cf4c156518ae935029cbaca079"
    sha256               x86_64_linux:   "5faea4deef4ca2df7e4514d5c6b5b4104b29ca7989681a1cbde5062d42324ab6"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ef/cc/93f7213b2ab5ed383f98ce8020e632ef256b406b8569606c3f160ed8e1c9/setuptools-68.2.2.tar.gz"
    sha256 "4ac1475276d2f1c48684874089fefcd83bd7162ddaafb81fac866ba0db282a87"
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
