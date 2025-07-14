class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.31.tar.gz"
  sha256 "de0d96664d9a276dbe58cf4b44a6861bc18b6fd4c0f41a97450c5b3509904ae8"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b5961c074fd15057a182e9791170306fa5e355628d16d4968d1eee952f4fd7c"
    sha256 cellar: :any,                 arm64_sonoma:  "6bfdb119e1307570cb966b0a348184ede846257494ef8ae67808299a6d03ab07"
    sha256 cellar: :any,                 arm64_ventura: "5695232966011416ad0432d69dc8220fe3b21de19d528fb887ace2f87202cf2b"
    sha256 cellar: :any,                 sonoma:        "fdd6937d7522236a3383d36f4658c74da25643d437859238f12c25f2083d0dad"
    sha256 cellar: :any,                 ventura:       "d977b03d537630583310e9951000a4992e8241eca720c39d60ea53d2c4cf8ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "424898f09a5cd5b1a77950c1ba3059bed8e0200d2e78ab33d5517decd2117f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e982e7d9982e75c46874e9790d826ab16e29b5af4328b6640f939ed26c2b56e4"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    # On macOS `_XOPEN_SOURCE` masks cfmakeraw() / SIGWINCH; override FEATURECFLAGS.
    featureflags = "-D_DEFAULT_SOURCE -D_BSD_SOURCE"
    featureflags << " -D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "FEATURECFLAGS=#{featureflags}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "[INFO] Okay... Here we go", File.read("test")
  end
end
