class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.21.tar.gz"
  sha256 "aa791fb36e26a2cb51d3982be259d38ecdc3e6af71900ee15ffb4e41d4c066e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836c84e485eedba1d490e01a93bdc85f950726cd06f8f26e8a2ab1ea8b1fe119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4553443818834c718c51cb87209e35ecfbd8b87e7330384d02167320a0e4cf9c"
    sha256 cellar: :any_skip_relocation, monterey:       "d750842037ca841a11c76652dd4df54a6b3d979af7d16f296ef52eda9b896661"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a9bf3fc2d4c840e5b2a98ea0089ac97ed96220f0c80d4c899fa550c6c3ea2e1"
    sha256 cellar: :any_skip_relocation, catalina:       "48d825f7179beed39599370307de30c76ce2fe32eb5b8ab8fa7af9fb179ede19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7a5bd8abcae89d19a137bf08fb57338c16681f2e9641e1b1e7fae148664aa69"
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
