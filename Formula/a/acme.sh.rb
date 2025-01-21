class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.0.tar.gz"
  sha256 "5bc8a72095e16a1a177d1a516728bbd3436abf8060232d5d36b462fce74447aa"
  license "GPL-3.0-only"

  def install
    libexec.install "acme.sh"

    libexec.install "deploy"
    libexec.install "dnsapi"
    libexec.install "notify"

    bin.install_symlink libexec/"acme.sh"
  end

  test do
    output = shell_output "#{bin}/acme.sh --list"
    assert_match "Main_Domain\tKeyLength\tSAN_Domains\tCA\tCreated\tRenew\n", output
  end
end
