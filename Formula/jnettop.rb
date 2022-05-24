class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/jnettop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "f2c6e3fed7a82f036acdf944ac6f27d11946995d961be3a0e804b8a9099a946a"
    sha256 cellar: :any,                 arm64_big_sur:  "1f1f3c5e26f7fc52b331300926a4aa93e1081b31cc20cb533f9b0791477cc101"
    sha256 cellar: :any,                 monterey:       "9e14b85dd45a7b23d5548948dff568bde0f0db0ec59c91baff292c896c804423"
    sha256 cellar: :any,                 big_sur:        "1a077d39b05adcb4ba5a5e777e6ff054ad3b910876ff3d49172057f050e8b39c"
    sha256 cellar: :any,                 catalina:       "13d9effd79e9b18faa659af615a7b68c7a940adf5eaee5e30806553e1a237f0f"
    sha256 cellar: :any,                 mojave:         "5b4a91804760ca7e39c76cbd16cd7612ed002d429f8996004e1da49d92839c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3617c2641b35e01517e783554157ece0999367fccf494fc9824618277464eb"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  uses_from_macos "libpcap"

  def install
    # Work around "-Werror,-Wimplicit-function-declaration" issues with
    # configure scripts on Xcode 12:
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Fix undefined reference to `g_thread_init'
    if OS.linux?
      inreplace "Makefile.in", "$(jnettop_LDFLAGS) $(jnettop_OBJECTS)",
                               "$(jnettop_OBJECTS) $(AM_LDFLAGS) $(LDFLAGS) $(jnettop_LDFLAGS)"
    end

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/jnettop", "-h"
  end
end
