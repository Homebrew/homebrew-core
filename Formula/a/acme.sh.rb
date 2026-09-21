class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.6.tar.gz"
  sha256 "0d3f9000ac44a6331314742a88c475f79134e24fc991997883652adc59efc486"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3a73e20dde99f68cb40a5b436e471a24d1f2e8b3712c9d89fc625c035b8cec2"
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
