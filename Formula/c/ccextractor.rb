class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.5.tar.gz"
  sha256 "821614d7b31d47bf3bf6217a66464b826c0f86d2bcde070b6fba74f54dff55ff"
  license "GPL-2.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "57424ac4a479d33b9d8e7fcf7daa25547f0a334e62c359c72fe3d564593a5a11"
    sha256 cellar: :any,                 arm64_sequoia: "b45ed020f9eb17eb5b2c0ca92f271bf527ecd723c0de429f5cfca3b6014f49c6"
    sha256 cellar: :any,                 arm64_sonoma:  "90394f6c8a27e460e2bcd81402cb63da19315e08c72dfa158b17dd7096b99174"
    sha256 cellar: :any,                 sonoma:        "b1268962dd74828fe4a82ab2fd96db286a5efc4fc982cea05cd6c38462ab0e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62191c5fdad0261d3f5ccb7f11edd33175de28a4e9d784153c29881c1f8ba979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2239762cc7c6f7bc3deab365a45b8a68625ba2c26fa96502c9f25d003dfd7f8a"
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
