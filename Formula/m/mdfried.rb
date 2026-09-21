class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.6.tar.gz"
  sha256 "143518acf0765e1cc4425b28b9d8059a6097ee08a6690dcf052e906b5a3947bb"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7e56b5ab30776c4a7d8a2781a4021b35f8c52f063bb48a4b6bb034dafab57731"
    sha256 cellar: :any, arm64_tahoe:       "8200f4462d736797dd8b7c6bff2aaf8c84e35f6fe4077d996d183d1ccd103c4a"
    sha256 cellar: :any, arm64_sequoia:     "0647a10c1b056efbd57ca9e0a35375224ce85e71231be509c90ece227cdf9ff0"
    sha256 cellar: :any, arm64_linux:       "b8ecc6a2d156844ebf351d5f7ee673b05ab81b926545c5110ac033f7d08c0cc6"
    sha256 cellar: :any, x86_64_linux:      "c159158f8b6583e2cb249bf3d38bdfe7e7f80b4c35ff4ef150afc4c37b0e04c0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
