class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "7d1bb0f157c6fb05877deb26ca1e733128708fc5b60959967c0dd297b7ed7840"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4e5d6d5dd979fc684117dbf90387975e15ea8e3f9771d8b4feef283dce02f889"
    sha256 cellar: :any,                 arm64_sequoia: "e15eb7ddb0be1a2700b3e0f28127e1e2b11d1c6fe7c7e4598ef316a31f22a73c"
    sha256 cellar: :any,                 arm64_sonoma:  "db3026048a96b2c2a0c0cd4110f7d2d2b9cc88d24e3a73835fa859c00765b2b5"
    sha256 cellar: :any,                 sonoma:        "2ce179ab2bf9dd06853717321ac9769eadddc3bb3b029314f32929b79163960d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da8a5c4ea556bc045059599eb320a807101db7a9823236d8344b3c5c3615ccb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39691e970db7506124ccce2cd722f79a5415630491583e8049b4ab65c9473b5d"
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
