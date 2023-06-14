class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.0.tar.gz"
  sha256 "a2e641d020b5dbd9bbfbeffe14983a29f481bdb22440e5971139cac3c1de6390"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56c8244dbbcbee7c6968c8208f6728d25af647b3d9bd3b90bc2fa8ab1d4df498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56c8244dbbcbee7c6968c8208f6728d25af647b3d9bd3b90bc2fa8ab1d4df498"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56c8244dbbcbee7c6968c8208f6728d25af647b3d9bd3b90bc2fa8ab1d4df498"
    sha256 cellar: :any_skip_relocation, ventura:        "7240a8dc22accffa0aef6ecdf2c55e842bff2f036dbbe5f4354c6be10777dcc8"
    sha256 cellar: :any_skip_relocation, monterey:       "7240a8dc22accffa0aef6ecdf2c55e842bff2f036dbbe5f4354c6be10777dcc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7240a8dc22accffa0aef6ecdf2c55e842bff2f036dbbe5f4354c6be10777dcc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517d65ad2a8f4e48c51b108e71dfe90dfae374623110326b32f0536f7abc03cf"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
