class Fierce < Formula
  include Language::Python::Virtualenv

  desc "DNS reconnaissance tool for locating non-contiguous IP space"
  homepage "https://github.com/mschwager/fierce"
  url "https://github.com/mschwager/fierce/archive/refs/tags/1.6.0.tar.gz"
  sha256 "1a19182bbce19e395aa7d2cba91322317bb1cad57357b778749986106e455a75"
  license "GPL-3.0-only"
  head "https://github.com/mschwager/fierce.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "96b093b0e668c92c6bb46ff8603f42460146ae4cd195978e8cbd502e7ce183f5"
  end

  depends_on "python@3.14"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Found: accounts.google.com",
      shell_output("#{bin}/fierce --domain google.com --subdomains accounts")
  end
end
