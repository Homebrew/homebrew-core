class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.24.tar.gz"
  sha256 "2b68bfb60ae0c490fb304933585d88d036ae940a76ff0f87380d6ac5301afd7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f9725c4dce7195f87b038ebdd47436a21d8157619a25a36fc836d517b9aeda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eaddf5b4dfe91aaaa7f1f68119584a14a77c602f784522fb98fdf674b312055"
    sha256 cellar: :any_skip_relocation, monterey:       "90d28b40fc525a87417e3a921ccbed318e5335460c0ef96e06981c8c6046e1e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "341f22284a2403aa93a731cb86a9a2ea59f457566319ac01c6cbed05352736ee"
    sha256 cellar: :any_skip_relocation, catalina:       "1d2dc50a6925dfc72a9faf0182587faf79b07f487e033bc5f17bdc1086e2c810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbac1735d4e9034422aa5aa30c891e8a69c68fef9be7c8b6e0c9c70845d61e03"
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
