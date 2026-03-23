class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.5.1/gpredict-2.5.1.tar.bz2"
  sha256 "c26ff5f9bfe9468bd48426dac4782f860c208960b0551feba3e38e364fbcd797"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1a47866daea3fd50e4c2996d322b071620254d5735c6c7f27f3fd79ef4565d89"
    sha256 arm64_sequoia: "acb958de628380732cd372d06f0051c365fa51bfa700a61a48fbe4a3a4eaa358"
    sha256 arm64_sonoma:  "8db3e7f3c3878078f8e31900719e66f23af0f38c3c243214dba7ad88ba140594"
    sha256 sonoma:        "af3b1cd8cc2473b646ce470e35b2b73bd0d58674b6e1e5eea275efa05d768b3f"
    sha256 arm64_linux:   "e0def017a93ad0ac1a26c49d61cf1c43c714d6fe09f7833c2a4db655c13dd35b"
    sha256 x86_64_linux:  "ea1a04cd9761d0a09bd50ad5ab0c616765835ad38b6b87e46133286366b63f5d"
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
  depends_on "goocanvas"
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
