class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7065528d9225521ad1f1b267aeeee77c476849f419109a79097e90b30c56c3f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20644c4d1aff1a03e919f499dcd86b3a1d1f26a488e6648f1261c15fc6ccc2fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2d18988887c9186c7de9fb05e997b69205d7e35adb92ba45997abb73c003847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28665ee718d23f2be3a0346ccfeebc005aad779dcf268edb948e278e3df379db"
    sha256 cellar: :any,                 arm64_linux:       "e209b7c51c029895fc7a6f864f0363f505ee8892f615ca8922c8dc967440d0a4"
    sha256 cellar: :any,                 x86_64_linux:      "3668b00c02d6e51b10d8a59728da98295c1b46486933c7df0c9eb36aaa587e40"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
