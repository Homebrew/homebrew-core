class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.5.2/gpredict-2.5.2.tar.bz2"
  sha256 "186907660a96a95e70df2212d9d783710bcf53079b1508eb55a13dbed60573bc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "d9ab2d3280d4329fd3f56a3d583eac3d606c29a8ba46e1f158b2e7a3fe50d54e"
    sha256 arm64_sequoia: "91159d82d835bf0aacf058c975eec6a3335cac2d485d1b25b38bacb3fdbd5aae"
    sha256 arm64_sonoma:  "0ee89cf98b62cb777eb770c6eb027821efa1aec058f1ba9aeaee7933c0d04b12"
    sha256 sonoma:        "22d91137ad9925c30e1e9333d79228986ae43e583e826c4ea057e0f06b1c20e6"
    sha256 arm64_linux:   "0bd70156ae632d56d3cba9291956f63a9c882f3ee7a5d0ab80a48c89cfd9eb8c"
    sha256 x86_64_linux:  "7a02d601451b1b15166e32b8ce5a54e3951dd3bd7efc1e9707d28637dbddb39f"
  end

  head do
    url "https://github.com/csete/gpredict.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hamlib"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "xorg-server" => :test
  end

  def install
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end
    system "make", "install"
  end

  test do
    cmd = "#{bin}/gpredict -h"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "real-time", shell_output(cmd)
  end
end
