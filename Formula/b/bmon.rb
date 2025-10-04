class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  license "BSD-2-Clause"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "93cdadcf5fec7072cb986a15fb5f6f3e405d09da4dbeb2048eff7b561b0b8af8"
    sha256 cellar: :any,                 arm64_sequoia:  "f32d98f5dbf21deda940949e6b11a722ad0d69a7acfc1841d2779ce5b3af12ed"
    sha256 cellar: :any,                 arm64_sonoma:   "f0b04892363966c2e28c0d4ac5a76a751acdeafbfdac6cf543a9b0db825c1aaf"
    sha256 cellar: :any,                 arm64_ventura:  "890364e7d54a6673fccb4091d9643e24ddb1dfd4a3b2102618cc0b7d67953771"
    sha256 cellar: :any,                 arm64_monterey: "321c0715286901cc997ead59058971667bb3bd491cd85cd3a82eca29c7ae2f83"
    sha256 cellar: :any,                 arm64_big_sur:  "8f20f07b392953df52502a35c4430ae3f080e4cf8b932a95fa66c149e04ff149"
    sha256 cellar: :any,                 sonoma:         "519c72fe28d46ab57034f262ce1972f2ca0d7dbf616c2c2c2adfc7d6034a9b43"
    sha256 cellar: :any,                 ventura:        "68229b2903b717a8a03d324aebf0bab686723c9284d0124127b562beafa0be04"
    sha256 cellar: :any,                 monterey:       "b81677fc05a116244cc98fee5d4dcf1a137923669f349aa5a78ac5cc93d9271c"
    sha256 cellar: :any,                 big_sur:        "c5a460a6ada9a74638176734db89e6e7fc6f8c171a8e580d06bb7b77b9432c1b"
    sha256 cellar: :any,                 catalina:       "0e5a38ac18b9a385c33eeedd7c64c649bad0a6160aada5725cf3c1b2557b74f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "00927e3a0dbf34649e09b491181022e05e8fb8b5c4924cc2f2bd1951228e716c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c35f5e85c98f864cb59ce589b03c05ce6dd37563a731d86c4491e8930449b8d"
  end

  head do
    url "https://github.com/tgraf/bmon.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "confuse"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libnl"
  end

  def install
    # Workaround for https://github.com/tgraf/bmon/issues/89 build issue:
    inreplace "include/bmon/bmon.h", "#define __unused__", "//#define __unused__"
    inreplace %w[src/in_proc.c src/out_curses.c], "__unused__", ""

    system "./autogen.sh" if build.head?
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
