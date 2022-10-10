class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.10.10.tar.gz"
  sha256 "d7cd322301b2f273474950a7bcae4180681825ba357c900b50aae5dadc44cc4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b979c5c176dac0b67fa52d0152b09585c2564b5244b40720e23e0b410a73171e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2abf045b554e023461b2b4e5c16439768234f149fdfc273a7b7d336d993e96a2"
    sha256 cellar: :any_skip_relocation, monterey:       "663c89d6965e271a59f9466feeedaf0500ee316dac7ef5ef060e9f7bdbf747d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "23d87fe60d4bbb6f2d3c1d4778f159d92aef3f23b3c2f046a618eb4d1ef55164"
    sha256 cellar: :any_skip_relocation, catalina:       "ea22e7c215f432db70f5fe6a2c41bbcd156b7fe3201d67457ca5076da94070f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef14b2f0187e7a7271f769e182a480f9586161c8da236729f22d0f48c3520c6f"
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
