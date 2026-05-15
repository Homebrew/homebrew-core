class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.3.tar.gz"
  sha256 "efd12b265252f8875269960b6b31830731ccce2b3e6ff8e7ecfbee21fde35ab4"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f323095950742f7e7899c48f5295433b55c6edfb7092eade86e16fcc74618037"
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
