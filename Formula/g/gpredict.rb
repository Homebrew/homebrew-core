class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.4/gpredict-2.4.tar.bz2"
  sha256 "c479b156496f65ef03c073f3483796f39507e35b996c33214c65698fc4bd8923"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "1adb214c6bebdb5a99c2482d613893e71fba7932a2006907bad449fa01e50659"
    sha256 arm64_sequoia: "e9136ead45ee0092801c3cf6d039609e0a704dc6f43077641ebdbd4996c48535"
    sha256 arm64_sonoma:  "652cab4dbf9efb373ed4e9c17d746c3f348f91c0574bed4ebb9973e25078681c"
    sha256 sonoma:        "d56ee32e47b52330cfa52b9c84ce171af036ba3c0e7ff38a3a2a4763010777f4"
    sha256 arm64_linux:   "b1550c71c60e2e05ebef97d653165b6603046a11d43fd2406b02713e91627ff1"
    sha256 x86_64_linux:  "a0d73ac43d3362d869e8be44e6fb0f5b6f48c22e6d83a92d0d3a3cb1d5f7e58b"
  end

  head do
    url "https://github.com/csete/gpredict.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "at-spi2-core"
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
