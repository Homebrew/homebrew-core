class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.167.2.tar.gz"
  sha256 "203c7b040fbf753d35c586c57d68dd64d345fdcb778388b6a97dee48829ace1e"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "d3b02af084ba4bebdbb09a771461e4599f9d4ea477a588283d410c25837afced" => :catalina
    sha256 "4447aa073ded240ab8b6fbcb68189474c2b6df1adbc0f4f775fc5cd5cf256c4e" => :mojave
    sha256 "3e45a983039e9d8a524ba65939818fc09de0792750a90b978d33881f1b2f1c2d" => :high_sierra
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
