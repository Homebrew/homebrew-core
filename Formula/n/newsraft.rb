class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.32.tar.gz"
  sha256 "a3b5f4935189316b5962658f29669472798a3e40d62b4f60d66644af3f04d2d3"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2409740a3d16d3de3710672a5b2ad5c543d39dd3cf5d6d61fe90362563a9529d"
    sha256 cellar: :any,                 arm64_sequoia: "aef5996f4f43703a4bf853f3c1bfffac22c4f26adafb56fc60febe38560e25f1"
    sha256 cellar: :any,                 arm64_sonoma:  "05376dd0ebeadf2d1be377c276e1b8239e2a6889c43a7cf111eea322a41575ee"
    sha256 cellar: :any,                 arm64_ventura: "4e9037da7751f16b74832954eb41c79e14db50f600f9e49daf149dbea3873559"
    sha256 cellar: :any,                 sonoma:        "6de16eff0be4e61a95f00f4cc819fe8f993ed8b6e38a8092ead3b1a35e31f213"
    sha256 cellar: :any,                 ventura:       "48fc2089152a6b78f4db25853f4d2364b7ea62592012868704c00db86426843a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6782552248c2cc1e59435acaf74f63a2379fa5e88e5af8734d27e62544558a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7235defd2c251363a8657498691f362540bacbf241b2ed8b32fb5b2c3427244"
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
