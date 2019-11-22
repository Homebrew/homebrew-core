class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.166.2.tar.gz"
  sha256 "fe4cfb84accf305692a31c288204b9e7a14a544bb01ae14a7ce9bfe05589b18d"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "d1c93a273d971d2ec5ca0d216f06a508c0a6c5a6932c45abb7e95e7ae2ec9ea9" => :catalina
    sha256 "421e4df99f7b0ba5d0de94997044f371373ae267ad4f9e7958f45f143bce5d4b" => :mojave
    sha256 "4f79dde31c2bc61d87f5d82b588ed7f6c02ff26cd816e4811f87c6fec764b109" => :high_sierra
    sha256 "2abd032fe1c24461b9b65a9d53f80786909d2039aec1b1ea84734fe47b47f099" => :sierra
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python"

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
