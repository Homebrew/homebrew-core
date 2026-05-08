class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "c9cb3a3faa22e01128632806229947741004c13a22041378778e3186b8a95b72"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7249f8d257877df4c56688549511200f52796de223ab8a8ac2a25ac9a0628a8f"
    sha256 cellar: :any,                 arm64_sequoia: "c6a46f5f5de431c61bf816f757caa11753706a185d368f5464b8dea44e870426"
    sha256 cellar: :any,                 arm64_sonoma:  "332f5b5652eb1ecc02bc33fe4371213b27056db6a757345db476ff050e969e2b"
    sha256 cellar: :any,                 sonoma:        "b29f3c890e8e729d8ab54a233f0132e46659087f190ba781b5454ba3bcd7bcf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e491cd94436551185e92e406de44094e3da270e15591e51e0a535984a3eae35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a071ebc2236efc63ab4a556ba0817866386c889fb1b61e8ce7b6e5ca5d203f"
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
