class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.6/gpredict-2.6.tar.bz2"
  sha256 "f4e6967cb2eeb6d74b8e8208c90dc8f4b1c00955ae1049753ad8352c927e54a3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "f8c9b2ea6c7c613968ed61ec00ef72cb897ede678f428ad5a2107c706504463b"
    sha256 arm64_sequoia: "9332a1c6ba2c43e207305c0bca832a84027895724c5e5149589aa47c183debfa"
    sha256 arm64_sonoma:  "a0cdca7cc480453838f440fe8a2103b97ef89ff4bf49ae2c885ad202ed80bfda"
    sha256 sonoma:        "5c0e019f9018ffe5ac78e68389b45c56dd3f33b9ffba0ffb0613e6234f71468c"
    sha256 arm64_linux:   "c52fdcdfaa81e8a571176bc769d8a7360b29dcc04fc0409a974912ef5bbc27da"
    sha256 x86_64_linux:  "6c985a8fb04516aac9e28e7bd717c20e784ca199bccea3a32a537c6028fa0420"
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
