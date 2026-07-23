class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.6.tar.gz"
  sha256 "d2bda9d2071ccf7a81a43c10e82ec00899b2a25b391c300e965274f92ad46208"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12c08c826b1c250658d66d379f72561580175beefe027cc0c171dffa67eba093"
    sha256 cellar: :any,                 arm64_sequoia: "0fcdc7c0b826a813a867b827dd893fe2cc37febbf6288f2a5d7b548044d6260a"
    sha256 cellar: :any,                 arm64_sonoma:  "a852bf9a730bd1551c295ba37541f8f70b39c5f7544a42e292735791a25dffef"
    sha256 cellar: :any,                 sonoma:        "123f78f64acb113f4d0115ff351399d7f4c7e370b53aed233294b8edf0647cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8594c9a98cd6eb8251c1c88cbcea50d1dd4ece4dfe8461664847558e4d3d3f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ef2ceeff67d6a30349edf4eeef1e452788f44f0c8d7d880c76cb58ae25a8c6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "utf8proc"

  on_linux do
    depends_on "llvm" => :build
    depends_on "leptonica"
    depends_on "tesseract"
    depends_on "zlib-ng-compat"
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
