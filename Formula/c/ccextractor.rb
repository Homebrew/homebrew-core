class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.5.tar.gz"
  sha256 "821614d7b31d47bf3bf6217a66464b826c0f86d2bcde070b6fba74f54dff55ff"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f0aa09821576492695638e9a18ad46146bcf707b1d05fb21acaee0366bf47fc"
    sha256 cellar: :any,                 arm64_sequoia: "d82db02d25dfcb70c32a72c9e9c6776fc554b2e454330d1c954229f801b1a052"
    sha256 cellar: :any,                 arm64_sonoma:  "8772c66a99b20e38da45853be84661b6afab8f6c82786f00742535c984dc0278"
    sha256 cellar: :any,                 sonoma:        "c05af963b7e418702626652d8a1d692b6ededdeede9f93744b72a447f1a7ad11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28ee674242b720a3393c2f1b0da9262a0f80e494f74478bc0675fb730a677052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e845311c9f2490dd8548b3154b10d44dd2a1e46a9e563107204fa9c8565c3030"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "utf8proc"

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "leptonica"
    depends_on "tesseract"
  end

  def install
    if OS.mac?
      cd "mac" do
        system "./build.command", "-system-libs"
        bin.install "ccextractor"
      end
    else
      cd "linux" do
        system "./build", "-system-libs"
        bin.install "ccextractor"
      end
    end
  end

  test do
    assert_match "CCExtractor", shell_output("#{bin}/ccextractor --version")
  end
end
