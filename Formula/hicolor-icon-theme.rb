class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz"
  sha256 "317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "62ad54e057594fe218a8d7b5829d979883dd1118d6b65343933e3b1f5f14241f" => :sierra
    sha256 "62ad54e057594fe218a8d7b5829d979883dd1118d6b65343933e3b1f5f14241f" => :el_capitan
    sha256 "62ad54e057594fe218a8d7b5829d979883dd1118d6b65343933e3b1f5f14241f" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/default-icon-theme.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    File.exist? share/"icons/hicolor/index.theme"
  end
end
