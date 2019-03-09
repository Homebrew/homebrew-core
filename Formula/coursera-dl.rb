class CourseraDl < Formula
  include Language::Python::Virtualenv

  desc "Script for downloading Coursera.org videos and naming them"
  homepage "https://github.com/coursera-dl/coursera-dl"
  url "https://github.com/coursera-dl/coursera-dl/archive/0.11.4.tar.gz"
  sha256 "63db680e92f130fc308bdeb0f69b947f57cfe3c4f5901837038a3887c4b47e8c"

  depends_on "python"

  resource "attrs" do
    url "https://pypi.python.org/packages/source/a/attrs/attrs-18.1.0.tar.gz"
    sha256 "e0d0eb91441a3b53dab4d9b743eafc1ac44476296a2053b6ca3af0b139faf87b"
  end

  resource "beautifulsoup4" do
    url "https://pypi.python.org/packages/source/b/beautifulsoup4/beautifulsoup4-4.7.1.tar.gz"
    sha256 "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.14.0.tar.gz"
    sha256 "2e2efe2be3f90577aca9415e32cb629aa2ecd92078adbe27b53a03e53ff12e91"
  end

  resource "entrypoints" do
    url "https://pypi.python.org/packages/source/e/entrypoints/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "keyring" do
    url "https://pypi.python.org/packages/source/k/keyring/keyring-18.0.0.tar.gz"
    sha256 "12833d2b05d2055e0e25931184af9cd6a738f320a2264853cabbd8a3a0f0b65d"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "soupsieve" do
    url "https://pypi.python.org/packages/source/s/soupsieve/soupsieve-1.8.tar.gz"
    sha256 "eaed742b48b1f3e2d45ba6f79401b2ed5dc33b2123dfe216adb90d4bfa0ade26"
  end

  resource "urllib3" do
    url "https://pypi.python.org/packages/source/u/urllib3/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"coursera-dl", "--version"
  end
end
