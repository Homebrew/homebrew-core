class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.22.5.tar.gz"
  sha256 "366f904940ff5e4863ab85862cc126d111c16dd83578d2a144d91dac2a09e43b"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c2db802211a4d6f9a76bb599951aaadbae197003f626e5f1e9036049ef2676f1"
    sha256 cellar: :any, arm64_sequoia: "9c4e5ddc51ac46a8b8914f1cc9a780808723c03fc3107e40362c85b11898da37"
    sha256 cellar: :any, arm64_sonoma:  "b212375ad181005a6e3f4339332120cfd30ee368ab70dc667d5dbb82933683d1"
    sha256 cellar: :any, sonoma:        "fbdfe32caf1b703b5e3e3dde8cc6e88f9752c2aae4d55c1ac1fad1270dec56cf"
    sha256 cellar: :any, arm64_linux:   "ec8147d82bc0077ae71d6053e9613d6da763b875335ed864c9a132db5dce8253"
    sha256 cellar: :any, x86_64_linux:  "798de72d8f2233249b4d9277359e2becf9f49132020da1bcb33b3b82051de5b4"
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
