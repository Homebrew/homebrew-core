class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz"
  sha256 "64424e96e2457abbac899b90f9530985b51eef2905951febd935f0e73414caeb"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4b8fc8d8c9e231bdb06bed94370887ab65d9fe2b5d4a0b7472800f4a2c762a58"
    sha256 cellar: :any, arm64_monterey: "beaa7b7c142e9635704927d78cdf38ba1a6798d24d43bba7111e733f4dbe51b1"
    sha256 cellar: :any, arm64_big_sur:  "9599f1b7c34eba5825f48c8889c0a270ff56872e0ae395e96f9071b3c279ae40"
    sha256 cellar: :any, ventura:        "e1cded13de699b99e626fe4434929d5988ef18cb754ebc9989799999f1509925"
    sha256 cellar: :any, monterey:       "d71a5fa314d3b85f48fd9e2c96c731de4be2ee63cf79d62499ac4854a629b103"
    sha256 cellar: :any, big_sur:        "d7a1c66c6bd5244878fbf87ed5561f2a7e2245305d0673a41eac817d37f332f0"
    sha256 cellar: :any, catalina:       "c978dbeb93adc96a2e479f9448d3d640910edd6edb7afb18efaa38e7bf3cb6b7"
    sha256               x86_64_linux:   "d14e0b834abf353f43019923a7e101dde8d3522989d9a762ed4a7e44a7c90000"
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
