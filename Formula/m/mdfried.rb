class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "af31a4ca3215a54ea826246cba8b2fbbb957164fd8ee7f8f253f751e98ff4ee9"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6d09fb5125fa782f66c718951b90fcf2c94434890ce8224af43beb11d5681b8"
    sha256 cellar: :any,                 arm64_sequoia: "90627161d40bfd25f87f879f3acebf8bb8d4b70d2b314ae42e54dcba4a9f013a"
    sha256 cellar: :any,                 arm64_sonoma:  "6b1eef3e88d8599874c733c9dfd8e40f64c3ba5113c7a0ca23dc0db1a8ed60ba"
    sha256 cellar: :any,                 sonoma:        "5d83fbfe0fe34114c38ff81823da7992ed95f52320445ba284aaf9e962fb0a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7e967b34689d2124a2c2018dff36515f409b00cfe221694d4a2d64789f48bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4b30df5c99b4929f2877ba2bb3c08ace94b6d136f81b29152ecb012e6325f0"
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

    cmd = "#{bin}/mdfried #{testpath}/test.md 2>&1"
    output = if OS.mac?
      shell_output(cmd)
    else
      require "pty"
      r, _w, pid = PTY.spawn({ "FONTCONFIG_FILE" => "#{etc}/fonts/fonts.conf" }, cmd)
      Process.wait(pid)
      r.read_nonblock(1024)
    end
    assert_match "cursor position could not be read", output
  end
end
