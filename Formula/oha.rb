class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "5fc3221635cdfa7c20c7d05ae908dff091952e844d1ee9f873f49fe47cb4bc8e"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9199d3fbd3733290c612dac23a2c2fc92171f835dc227b4b647dd6b5c875d348"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8feaa7bfe4d2ef608787271994b0d596425ed1c7fb9f2c50c382a5f9050bcd0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d85ee6ae86bdc422b40d8423140d79cc5af110039544db67aa479c47a17525"
    sha256 cellar: :any_skip_relocation, ventura:        "917e13fb5f4e56c585aa7249ec3b333f1827b1718bf15751102d971fd61f0720"
    sha256 cellar: :any_skip_relocation, monterey:       "7de3fc5f187855f119e1eb05b68af4c4576f67d11fe57fc56db75e96c277d353"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee1f86d67dabb618b7ce54e61b41ce6addb73cb795390aaed994505f59fca45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "245b75dae050689a45defeb8b418c268959bb0d038064d2533dc041f6dd5c490"
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
