class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "afe9ae186a7245a22f8021a0da682a399dcd5fc4c689f98dc2fcf388173507ca"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51a09bb88e28357218d2e4fab1c98b0837b83ba7ea38b34fce96cf1f040a6947"
    sha256 cellar: :any,                 arm64_sequoia: "184847f06ae4ad5ee8b2b6663ce36bf995d1ee096aba6043eca780a2723ef951"
    sha256 cellar: :any,                 arm64_sonoma:  "4e9470e72bf984d489402faa7e40318d67e64e9a69225e7441cb9da1ffafb8e6"
    sha256 cellar: :any,                 sonoma:        "f634cd687496dd5a0420bcdc2dfa2d0c0bf7dabb3e6467c259b2d51281500a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e458523c4fec8539d58967a12dfd9f0896d7fbcd0ad6916f6645d46586b1d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695a0867b8cd573eeb815f7609af82df48d6de47d194ed7d0d4c7e31ec7e2703"
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
