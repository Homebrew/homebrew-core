class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftpmirror.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.3.tar.gz"
  sha256 "87daefacd7958b4a69f88c6856dbd1634261963c414079d0c371f589cd66a2e3"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8b7481a7c316dd293ddffc9a58fcfbd5289be84f4c2d39d6f4e69da6dd36bd80"
  end

  head do
    url "https://git.savannah.gnu.org/git/dejagnu.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "expect"

  def install
    ENV.deparallelize # Or fails on Mac Pro
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--mandir=#{man}", *std_configure_args
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"runtest"
  end
end
