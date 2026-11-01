class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.7/gpredict-2.7.tar.bz2"
  sha256 "1d58b0fc4f13173cde6f64277a8b2e36e84cf0f2a27d8b8d0e48b76780b1236c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "853ff92e19db578d2daab8f38e1b836ef37b62db6d5ccc98085a25225cc17a8b"
    sha256 arm64_tahoe:       "ca08f60f1d77d7d11636c8a866792e03d6035bbc94eaf4b0bc686fef0e8bd443"
    sha256 arm64_sequoia:     "36d1de6214f153295991fe9be7e4fa8cc61fb433d01c9f305932f53719b6f97d"
    sha256 arm64_linux:       "d8d2cebac568a0361b3fe44c262ca858e3172da6fe425ebf0959cba4ede27cfe"
    sha256 x86_64_linux:      "9e0d73f9c585f31f5ce74f0b9820e09ff1cde0f7289e634bed0b3f868fe587f0"
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

  deny_network_access!

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
    cmd = "#{formula_opt_bin("xorg-server")}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "real-time", shell_output(cmd)
  end
end
