class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.3.tar.gz"
  sha256 "f0ffaa33e93299b38058c507da2945976a4b350c92cf1c4b3649586444395dfd"
  license "GPL-3.0-or-later"
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76263c5243859ce83f0e66ee9d822ab72b7ef0d61436cd7dfeef84a8deb1a106"
    sha256 cellar: :any,                 arm64_sequoia: "52a93e1cbbd481869c51f754a20bfc490903585ef4ce7cdb136d7638267d1c0e"
    sha256 cellar: :any,                 arm64_sonoma:  "07dc03c8202ef66c3322f8b6d1502b85fc4555bdb90fe16021db78f58dc25d3b"
    sha256 cellar: :any,                 sonoma:        "d70569fe2e223bdefa6d7ac96de2b7679df5ec75383c4df70453d08d6ecccce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66de8c5c0b02ea39ac1952c77c605e91155a2a516eebcb471de151f5c438241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468db466a148a516531a8f82d4190cefbcc3f5bef1ae562bfa91472d1e0f0ccf"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libtiff"
    depends_on "libx11"
  end

  def install
    args = *std_configure_args.reject { |s| s["--disable-debug"]|| s["--disable-dependency-tracking"] }
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
