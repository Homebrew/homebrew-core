class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https://github.com/codesnap-rs/codesnap"
  url "https://github.com/codesnap-rs/codesnap/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "e1636f08781fdb6e380428bd54f458f59b7764702271a7f2f407ad4432753c33"
  license "MIT"
  head "https://github.com/codesnap-rs/codesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b09e81e2e477b4766f7131c2c7cce96c0c4f324ed6b536b8c7f620be8925ed8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9984bfb2152fb6cb6d32f5dadcbf192786fe6e6da6a5d1daabebeaab13df014"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45c584ac455a83be1b596f9a8e063bcbb5300d7ff75d43641737b423b41d376"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a408a988e5588a6105fe3fda0fc271aaebc86c84f97fbacf8a743f1787b5925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd2da94e62d3648e54e1cb6428f6842e500e46c7a04bcb83c7c1147aaee92d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82461844e1d7743af3f1ed81053a3478c68161d031b6de6cf6715d0340b50579"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cli/examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}/codesnap -f #{pkgshare}/examples/cli.sh -o cli.png")
  end
end
