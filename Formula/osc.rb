class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.168.2.tar.gz"
  sha256 "070637e052ad18416cf27b49b53685f802addac8da9f9a36ac8069dcdb1757c4"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "d3904d858e171e390e66557cac6adfcb4088763cfc3d9d20d4db230a18a29325" => :catalina
    sha256 "3fa16b437b3b85f672f35b4ca47c588edd5dcdd04a088b9e198abeb65c1cff33" => :mojave
    sha256 "f140234da093e1ed0a0cc586e6972a690131991e5667cee4147ea5eed1c0a2d1" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python"

  uses_from_macos "curl"

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/67/b0/b2ea2bd67bfb80ea5d12a5baa1d12bda002cab3b6c9b48f7708cd40c34bf/typing-3.7.4.1.tar.gz"
    sha256 "91dfe6f3f706ee8cc32d38edbbf304e9b7583fb37108fef38229617f8b3eba23"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    # Fix building of M2Crypto on High Sierra https://github.com/Homebrew/homebrew-core/pull/45895#issuecomment-557200007
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
