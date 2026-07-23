class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.4.tar.gz"
  sha256 "e5f8e187bbf5251e0cd8891f2622daab9850366bd17bea9f92c2fe2ee091fd32"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30fcd885633e9d644317dcc96fcc7499ea2e967715d14a5c9aec7389f3bbf647"
  end

  deny_network_access!

  def install
    libexec.install [
      "acme.sh",
      "deploy",
      "dnsapi",
      "notify",
    ]

    bin.install_symlink libexec/"acme.sh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acme.sh --version")

    expected = /Main_Domain\s*KeyLength\s*SAN_Domains\s*Profile\s*CA\s*Created\s*Renew/i
    assert_match expected, shell_output("#{bin}/acme.sh --list")
  end
end
