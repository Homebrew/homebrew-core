class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.5.19.tar.gz"
  sha256 "1555c3ce9f1f49b2f1d31d6475b0379ac28628eb1b5e674855c2408277c47d1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6ff839cb5eeeec080883f6fc923050e22f8afecb74b20fe77e31ba478ada28a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2cbcdb5092a16f6c135dfbc91054e96e7be828b449b80bbd48ea13b61c9d315"
    sha256 cellar: :any_skip_relocation, monterey:       "2a6b772a5930ea76e5ac5576f6f42c9f0bb2d0a1f234529822f573f8d87433e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e2ed44f0592e9495c4692dcfaa9cbe071363fb0f8a77ec5f0f530998965eb6"
    sha256 cellar: :any_skip_relocation, catalina:       "1d578232c01522b803185d3173ff63ffdfa38b05ca23bfcac18c7447386b8446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948355777be5adf0352fc36b71c926705cd352dfcfaa88e36f6a086347f5dca5"
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
