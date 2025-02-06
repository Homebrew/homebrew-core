class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.0.tar.gz"
  sha256 "5bc8a72095e16a1a177d1a516728bbd3436abf8060232d5d36b462fce74447aa"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed468ee7ca382405545a7c022fcf28f45e8cdbc0feb87e0e4c5e64018600f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed468ee7ca382405545a7c022fcf28f45e8cdbc0feb87e0e4c5e64018600f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ed468ee7ca382405545a7c022fcf28f45e8cdbc0feb87e0e4c5e64018600f74"
    sha256 cellar: :any_skip_relocation, sonoma:        "45d864aacf2a2e4d2eb4ec6b2eea0f8d1f65fc2f533d549d780f7e03f54afc4c"
    sha256 cellar: :any_skip_relocation, ventura:       "45d864aacf2a2e4d2eb4ec6b2eea0f8d1f65fc2f533d549d780f7e03f54afc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ed468ee7ca382405545a7c022fcf28f45e8cdbc0feb87e0e4c5e64018600f74"
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

    expected = if OS.mac?
      "Main_Domain  KeyLength  SAN_Domains  CA  Created  Renew\n"
    else
      "Main_Domain\tKeyLength\tSAN_Domains\tCA\tCreated\tRenew\n"
    end
    assert_match expected, shell_output("#{bin}/acme.sh --list")
  end
end
