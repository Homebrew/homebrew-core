class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.10.tar.gz"
  sha256 "fce4a1e401b6189c103d2b1203261d0bfbf45985c6f3fa44c51b186b13fe7a7d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "49668adaf966f1af503e4f612615d45f5d376abccd9d66428ca9dbeb21020f78"
    sha256 arm64_monterey: "0b1f4ff5e7d3a55464a2fa059ac7f23bdc43051a7df6ecafe49f1dfb95833155"
    sha256 arm64_big_sur:  "2dbc659ce5d464a950ee96519777b21934dbd13a1af071a27316b70af05552ea"
    sha256 ventura:        "82e08449d2df553f0ab475768755f393ebb8dc1940c0aeafb221863e767efc77"
    sha256 monterey:       "e619cd689cf79cbfee94d8808febe6acdf6f39b5446a27e3c74be8d048edc9d2"
    sha256 big_sur:        "39b2817bc31c4eaacddb10eb5ed645684537fa2aa568df840753eb7e711a5851"
    sha256 x86_64_linux:   "7e39faf9884060fa6f1babb4acf2e72dcbc4cb5cefee4c0fe52d708c776a1e11"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre $@",
      "#{ENV.cxx} -E -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
