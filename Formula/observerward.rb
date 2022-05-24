class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.5.19.tar.gz"
  sha256 "1555c3ce9f1f49b2f1d31d6475b0379ac28628eb1b5e674855c2408277c47d1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817b40e407c2c735ddd9eee7f00572dfa261e8135234e8eebcc896bfedaa966f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad9d2a43e931fad347937a2fa7f52040a716aabdb5d7af05338fe5c5d700fdef"
    sha256 cellar: :any_skip_relocation, monterey:       "cde10151ad5c101fe9be4d360e41867a1578b2e0efebd2125c1ef444a88da776"
    sha256 cellar: :any_skip_relocation, big_sur:        "566bf2aba356c40864d455461b51ec1072ae186043d6658fbfda5cb753a63dd4"
    sha256 cellar: :any_skip_relocation, catalina:       "c454a26e955a5e9fe0834baa63615b0fcd4c4d1891a3665d9159237fc4a2fb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c31eabd0adacf89098651d6297e06fdb1cc0a047f4347225433575459bcae5e"
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
