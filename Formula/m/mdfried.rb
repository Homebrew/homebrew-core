class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.4.tar.gz"
  sha256 "d176d761e82cfb574b8997dc4125d1d6c656ed469f66b3a3deca7f851a793944"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6399f76a432e9ecad93170ffad5dd7603859f6734706c9fdc76be11fdeeaef20"
    sha256 cellar: :any, arm64_sequoia: "99af53a18e42dd0d71d110f9e97501fb2ef288bbbe434da8895a299d13bb5738"
    sha256 cellar: :any, arm64_sonoma:  "9cf3ed1af6f520f27195f7ea071189ae386800449e9d3887c0bb9a18abc8d549"
    sha256 cellar: :any, sonoma:        "5b9757b44742cd000e36be5f03038cf57e9cb4fcb011d5757ddba0c9c751b6dc"
    sha256 cellar: :any, arm64_linux:   "61b1bd5db30766cdcbc0f7e6ca435651a2d070e64a91319770950af478ccb8cc"
    sha256 cellar: :any, x86_64_linux:  "60019137d62b1d005939cc6d2185f3bfefa7a7f73be3d3a4d09e69294ceb3934"
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
