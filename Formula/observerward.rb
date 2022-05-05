class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.5.5.tar.gz"
  sha256 "493da7c3cd0941f306cc5747ca177b238997945286dad7065a372a7baccbe23e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e2dc5cbec5126dfcc49173c2ec5438a28f88a68da50682d69d7f1c4b7f6aeae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eec0743074017d3964915a6d601e31ce96e11f760c77069f3d0d72607a334e11"
    sha256 cellar: :any_skip_relocation, monterey:       "6efe0a8a383ffe4754f641595abde4b5ad6712528dc877f1608618adff319c47"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7544ff93728b534940bf0e405f7b32dea786d5749da8b66525c2bb059bbefdc"
    sha256 cellar: :any_skip_relocation, catalina:       "ff5465e9b20c13fc13f5d4722aec3548948138b3cb5b6eb594c05073d63a3c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2a594d45daee88326ac39e4ae444a38770737b8beea36d82dfc786ed3fb239"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
