class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.7.tar.gz"
  sha256 "1b674f31aab8844e0ed770d4a5907a777d259f58b476c5f9334cc846832081e7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aead95c71dfadd1a354733878304968a5d58709027dba9c8147a76e8537ae3ff"
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
    bash_completion.install "acme.sh.completion" => "acme.sh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acme.sh --version")

    expected = /Main_Domain\s*KeyLength\s*SAN_Domains\s*Profile\s*CA\s*Created\s*Renew/i
    assert_match expected, shell_output("#{bin}/acme.sh --list")
  end
end
