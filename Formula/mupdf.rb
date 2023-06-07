class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.1-source.tar.lz"
  sha256 "33b00317b93bc404cffb67c91a5e6bb1b62051536829171c5f75cbaf2c1ea7df"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed1c2231d4616bf3e6c6d3947b11a6b1dd8f2a8f0bca389e07628755ef6fc07f"
    sha256 cellar: :any,                 arm64_monterey: "6cefe7bc54d9ebf2c1d2c40bd21310d62adcfc43da2779fe2f301580f7e2a860"
    sha256 cellar: :any,                 arm64_big_sur:  "1d9d3ea021a4f85b68d02562e66d9816255d1074cfca89e773f8620eedcaf03f"
    sha256 cellar: :any,                 ventura:        "e69eb0538e411795ac86618ac30027c69fd8b22d4d96747f12810ab3f3d82398"
    sha256 cellar: :any,                 monterey:       "05798563d98e46772ef7bf465db66c1790ae675511fe6db74b11de4839926927"
    sha256 cellar: :any,                 big_sur:        "c5d973f6d66ec10a25fc07e0e940a468d592d40ce01155148ba3b4e561649cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d413092a8b4e51719761ff5bb0f7ad09a45a86218879ba0dc303a395171897"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| path.rmtree if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkg-config", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkg-config", "--libs", libname).strip}"
      end
    end
    system "make", "install", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
