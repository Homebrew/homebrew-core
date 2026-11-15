class Gtmess < Formula
  desc "Console MSN messenger client"
  homepage "https://gtmess.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gtmess/gtmess/0.97/gtmess-0.97.tar.gz"
  sha256 "606379bb06fa70196e5336cbd421a69d7ebb4b27f93aa1dfd23a6420b3c6f5c6"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 2
    sha256               arm64_golden_gate: "c6d0bdc523f6f346283161551179074e1e9189eb636ee76e5f9ed0806ef1e35e"
    sha256               arm64_tahoe:       "f1c4a256b74ceb1dc3de6e6bacf62639872a48d5ece557945193398b443ace33"
    sha256               arm64_sequoia:     "d64191c76570b2cf0b0b9326717c850334d917e7f4fae3523353cd96996d3956"
    sha256               arm64_linux:       "58b93d7529dcd3393909e80ecc60cf4cb7a4fa7b55b520a8b78136eab5530855"
    sha256 cellar: :any, x86_64_linux:      "42eca8ca77ad9c4ee59c164c415667499faca23bb2f3b9f588b78d1ab170918f"
  end

  head do
    url "https://github.com/geotz/gtmess.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--with-ssl=#{formula_opt_prefix("openssl@4")}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"gtmess", "--version"
  end
end
