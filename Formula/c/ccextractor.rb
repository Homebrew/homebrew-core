class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.3.tar.gz"
  sha256 "17037e8cc52773d3c9a88dcaeb1921cec9a0e4f92ff355fcc318585da41c25b4"
  license "GPL-2.0-only"

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
