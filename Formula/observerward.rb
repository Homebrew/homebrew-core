class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.1.31.tar.gz"
  sha256 "c8bb3104590419589a791ff481017b4e328a529937a88fc37398985f8a8463b3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e97b2ae8bec6ad284cd7af783630d92071beec8650976a781921263096a5b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804a1443b1b59ff2032e95fe0f841c716384ce4fda4e66b80cd753112fcc503e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "995e3d676cebabf5f4059886703274fb5a22425c1294d54509d275cd40c70b43"
    sha256 cellar: :any_skip_relocation, ventura:        "0a9bd23fb59607601b32243fc3cded367ddad5e21c3875e95b974587df734195"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a83610ab5cda6d40a9d9f3b5d9d7c45d118eebeb70a061d8b19af90447aa10"
    sha256 cellar: :any_skip_relocation, big_sur:        "3737f970cbe07aced313be71ec0de779152c360ee20796715cf06c60a8905295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bf989118f0af672200dfffe5a8efdad58d4ad97f772b9f2656383436dec2286"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "update", "--package", "prettytable-rs", "--precise", "0.10.0"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
