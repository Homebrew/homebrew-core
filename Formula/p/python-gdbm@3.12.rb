class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.2/Python-3.12.2.tgz"
  sha256 "a7c4f6a9dc423d8c328003254ab0c9338b83037bd787d680826a5bf84308116e"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b57278030c6bc53d605282f55ac8b3c405f26b66ed9594858b0b2f64243a5211"
    sha256 cellar: :any, arm64_ventura:  "67b46fd4027e3332d0a8db95ff5f1af4bde1a1fb14f460996738ed36efedb99e"
    sha256 cellar: :any, arm64_monterey: "9e4843211c412e29c6fc8b2ead2edd0c999c67c5b0ae058c0277ab51d9127a83"
    sha256 cellar: :any, sonoma:         "b5d32a47d26373140044e9dd7d466a282970722b023d0386321dfb2e8bfbf105"
    sha256 cellar: :any, ventura:        "934d91775a816281b5c2f45917995ecd759d7391a742848dcd0cdd52b4194b07"
    sha256 cellar: :any, monterey:       "1b638694f6b24c25c01f2f93040853aa4ec28845fadb2960fbd4857f42e08ecb"
    sha256               x86_64_linux:   "0aa6c6997e05ec40bdb2b313a0f01971360a331dcce67ecdbfe6083f1a57598f"
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
