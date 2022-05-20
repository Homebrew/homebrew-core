class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.1.2.tar.gz"
  sha256 "6fe6a45c9acddeb2e8baab84f93fc8bdb04e141639859c52715cba7e57665e97"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d617d05683d1c666f8e00cc05a0e8e0c7d81fff44777bd6b12044b43712214f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41839511953c5bda8f7fef793cde6487b030dd7ce7af5beec2bc58ad5de109d7"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd97ca487a988880facee84a0f1d9238a216ad3835fb9e63da508faced1d661"
    sha256 cellar: :any_skip_relocation, big_sur:        "fafc30724738149ace0e875d2f6da5fb581e3d81afd3844ed5801998a88a4237"
    sha256 cellar: :any_skip_relocation, catalina:       "ba1e48faede9986e074fd533efd93ffa26dee50ba8c8e6a3383f5dbea8f3f83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ecec1c93c72a60ba7b7dfaeac148eae4e188d7a2e5f5c4bab90c8590ef70a30"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
