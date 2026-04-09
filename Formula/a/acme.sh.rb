class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.2.tar.gz"
  sha256 "a51511ad0e2912be45125cf189401e4ae776ca1a29d5768f020a1e35a9560186"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc4d42523258dba4a4c1c9b64668577023e123887971d5a1ede2ed1b33de39c1"
  end

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
