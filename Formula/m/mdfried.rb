class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "e828d5ec5202b83c1d70c390b21efa164beb3920caf15684dda5534f19673e4b"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2b7a4e77482b847503470a887bc34f52894ca06a13f22b09c4378650113bfe8"
    sha256 cellar: :any,                 arm64_sequoia: "f2964a8e3a5f9fbdd62099ff6f32b018e11b933d8d92363d5fdbe40c83b8c6eb"
    sha256 cellar: :any,                 arm64_sonoma:  "710cb27eefcbeb691b8fbba5d2a30480124ceae2bcbe977bc6c2c5d06361bf43"
    sha256 cellar: :any,                 sonoma:        "f06850fb2fa7569eb1ead953469b6aee726c5ed6ecfe85c9025de7c028a91a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff7a08b0acc4f3a6506f1292708ab646b342d7def4ce86128ae670735a85dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13660668a62da8f3edc8139750d69f403f46824c9f46a8f659e5946ee043ba0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"mdfried", testpath/"test.md", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/mdfried #{testpath}/test.md", [:out, :err] => output_log.to_s).last
    end
    sleep 3
    assert_match "Detecting supported graphics protocols...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
