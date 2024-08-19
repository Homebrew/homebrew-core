class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.11-source.tar.gz"
  sha256 "478f2a167feae2a291c8b8bc5205f2ce2f09f09b574a6eb0525bfad95a3cfe66"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8290f9bee8d3d592ca6dae07a152651a5d386e979940992dc034ae1a7836f6f"
    sha256 cellar: :any,                 arm64_ventura:  "84d7627be727109d54978a31ec04c0f3d4685dae93207c5d40d14ddef004bddd"
    sha256 cellar: :any,                 arm64_monterey: "853102de018e979b14923af099301111f75d435078d7d027e07c0013a7a9cbc8"
    sha256 cellar: :any,                 sonoma:         "b4cd684c7649c848ce80aa7657d7236a695a89282a44ec95ae7de20385ddb652"
    sha256 cellar: :any,                 ventura:        "f8846a1c77aa6bdfd7925edaf46a57ff6920e0f429fa2d9f2b6b6c96b326c868"
    sha256 cellar: :any,                 monterey:       "8ed2477a192b75e939077b753118852ccec6a8de8dd052794aea299891cfabf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aafc7ee71749329c186c19c1d2aaa8cca880aa81e56f788a150de6070e8e0cb1"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools", because: "both install the same binaries"

  def install
    # Remove bundled libraries excluding `extract`, `gumbo-parser` (deprecated), and
    # "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract gumbo-parser lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_GUMBO=no
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
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
