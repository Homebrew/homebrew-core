class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.179.0.tar.gz"
  sha256 "543a9e1a4f2dc722a5228b41a8da92867a35fa52f9701dc213108fa9b35085e8"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a63a9a13b4e4380692f6c1b1ab5aed7865cb9f3ba84f29ba58d2f77b1e09d09"
    sha256 cellar: :any,                 arm64_big_sur:  "0cfedd28a9fd235111cea2817e36d6a8b71878cdbc7aa9497891f857db5db93f"
    sha256 cellar: :any,                 monterey:       "b14b349dc7cea70c461e489e9c5499bab0a7f72a13c3423606321a1e9097a335"
    sha256 cellar: :any,                 big_sur:        "833c96311a4de9e2e99e75171b1eb34b46776c9647b7c178a28c64632e56a853"
    sha256 cellar: :any,                 catalina:       "23a2e720a825354d9d56e7cac3aa12828c087cc4c75e79492105fac4d400a406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdf8b4db437e9d3dd64a4938c06895e829f1a316258a1697251d4f3a3aaf11c7"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/2c/52/c35ec79dd97a8ecf6b2bbd651df528abb47705def774a4a15b99977274e8/M2Crypto-0.38.0.tar.gz"
    sha256 "99f2260a30901c949a8dc6d5f82cd5312ffb8abc92e76633baf231bbbcb2decb"
  end

  def install
    openssl = Formula["openssl@1.1"]
    ENV["SWIG_FEATURES"] = "-I#{openssl.opt_include}"

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{openssl.pkgetc}/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
