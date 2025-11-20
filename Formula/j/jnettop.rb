class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://sourceforge.net/projects/jnettop/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/jnettop[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "94be630d1e700e5da48e52eb85019003f81295f9afd49c846296943881962a17"
    sha256 cellar: :any,                 arm64_sequoia:  "9660bd7bea038b091d0e0fdee7bbc5daf4c764ef2869282e6bf8e619f4a8d3f0"
    sha256 cellar: :any,                 arm64_sonoma:   "a06b56e12cf6bb3d313090095bdcc0b3e899d23dcd122cc80af8c36e4ba6b474"
    sha256 cellar: :any,                 arm64_ventura:  "d9309bcae09fec8961c974c65107b4d6cab9761d171c7d4d54cd0c8bc7842337"
    sha256 cellar: :any,                 arm64_monterey: "f2c6e3fed7a82f036acdf944ac6f27d11946995d961be3a0e804b8a9099a946a"
    sha256 cellar: :any,                 arm64_big_sur:  "1f1f3c5e26f7fc52b331300926a4aa93e1081b31cc20cb533f9b0791477cc101"
    sha256 cellar: :any,                 sonoma:         "9cd2a14ec9e61fff8a91107b290aa603066f3f613cd3a95c9c7311eb3355e307"
    sha256 cellar: :any,                 ventura:        "a37b6e72480a3c0945b6e13fb651e2797199aeae23fe73e85804e84c3b1db723"
    sha256 cellar: :any,                 monterey:       "9e14b85dd45a7b23d5548948dff568bde0f0db0ec59c91baff292c896c804423"
    sha256 cellar: :any,                 big_sur:        "1a077d39b05adcb4ba5a5e777e6ff054ad3b910876ff3d49172057f050e8b39c"
    sha256 cellar: :any,                 catalina:       "13d9effd79e9b18faa659af615a7b68c7a940adf5eaee5e30806553e1a237f0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a06d489b070670f237da6659aa5c1803bd5ec72b8b07540b00b14d392879402c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3617c2641b35e01517e783554157ece0999367fccf494fc9824618277464eb"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    # Fix undefined reference to `g_thread_init'
    if OS.linux?
      inreplace "Makefile.in", "$(jnettop_LDFLAGS) $(jnettop_OBJECTS)",
                               "$(jnettop_OBJECTS) $(AM_LDFLAGS) $(LDFLAGS) $(jnettop_LDFLAGS)"
    end

    system "./configure", "--man=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    # need sudo access to capture packets
    assert_match version.to_s, shell_output("#{bin}/jnettop --version")
  end
end
