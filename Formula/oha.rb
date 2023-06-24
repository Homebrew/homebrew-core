class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1cdd405c0111a93e122c48f2fc6c9b2f0211872077f17e9466e472e721eed36f"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86d3a1ad054afad472cd3fbb7daad2891c7907df54d1d57abacc011d155d7578"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46b660d2e3f239bff424e947558c8ea17b0d4637518f89b9e48fc2ffec506e1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85dd805e5a4dad094704cce3916ffa416b581dcdf9fdb07a14f8facd253d36a4"
    sha256 cellar: :any_skip_relocation, ventura:        "75168b87e796f4ac945857a1a7fd392c5bf5fe10bfc1776e92865f278485ff31"
    sha256 cellar: :any_skip_relocation, monterey:       "341bb3e1ec8545c29279391bf62282099983b90936f45f45c31ed345552573ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "a96798751cb5b3c67c1ff0625d10fc0cc0f750f380258d016564c14a76706ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98afceba88b2d65f6512ce8a4434eea7a512a3b61c793c1debf5b29519e9415b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
