class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.2/Python-3.11.2.tgz"
  sha256 "2411c74bda5bbcfcddaf4531f66d1adc73f247f529aee981b029513aefdbf849"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c5233b949c729499a354eca9e298180b2979d89a349c9289d308afba8c17eb8e"
    sha256 cellar: :any, arm64_monterey: "eadd4afafb34b0b677d31bc8b40e35c8137c8d073f5daa9828d2ca8373e4eeea"
    sha256 cellar: :any, arm64_big_sur:  "fe062a76322911c3e0d4736f1e85a5e9e855217ed1d4ddb99929c5f64ebda5bf"
    sha256 cellar: :any, ventura:        "172f93f9bb432b849b45e9c892bd95abb7492a7ab7fb283a871c984be7fd9e8b"
    sha256 cellar: :any, monterey:       "12cc6999b80114664394c1095f4a8452d90b01d07d1943f0b141dc1478ba8720"
    sha256 cellar: :any, big_sur:        "e3134356c53d8dfbfaee154d521a74d22e2c60ccf807c1d63bb0ebf9dd83735a"
    sha256               x86_64_linux:   "b91661db40fb79bf1491c16aeaa601a3c9f0c84d5deb546d1d458208964a3760"
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
