class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftp.gnu.org/gnu/poke/poke-3.2.tar.gz"
  sha256 "758e551dd53a6cce54ec94d8fc21fa4d6b52a27d1c2667206d599ecdc74f0d97"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "ad466d08cfc1f8a111ecd1e6d4a9b33e5a475eb4103a476dc130c69c466cdde8"
    sha256 arm64_monterey: "1b29c27f78cf3203d519ecacb589337de8f97d3d9b75918d25e7fb52bfd2f05a"
    sha256 arm64_big_sur:  "8290b00377d7e2927695a4646d616a50221eee5d74b7b0a494c137d67eca88f7"
    sha256 ventura:        "759a3b1dac86cb114e24fa154669efc7a4a0bf2e94ca1b8ea4cdd2dbf15c54bb"
    sha256 monterey:       "da4b2d5229771856cd3f8d24e9433c742378d7345d8c35faa42a33dc49d081a7"
    sha256 big_sur:        "29954a5423bab91819d44e509f802ebd36b57998d692e0fd663f382d1ebefc8d"
    sha256 x86_64_linux:   "bf4d9b327b73728305921795fce1e405314f9e7042a08e002ab03d5516cd6721"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gettext"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pk").write <<~EOS
      .file #{bin}/poke
      dump :size 4#B :ruler 0 :ascii 0
      .exit
    EOS
    if OS.mac?
      assert_match "00000000: cffa edfe", shell_output("#{bin}/poke --quiet -s test.pk")
    else
      assert_match "00000000: 7f45 4c46", shell_output("#{bin}/poke --quiet -s test.pk")
    end
  end
end
