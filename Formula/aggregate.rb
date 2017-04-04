class Aggregate < Formula
  desc "Optimizes lists of prefixes to reduce list lengths"
  # Note - Freecode is no longer being updated.
  homepage "http://freecode.com/projects/aggregate/"
  url "https://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz"
  sha256 "166503005cd8722c730e530cc90652ddfa198a25624914c65dffc3eb87ba5482"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ebe7aa16c7cf36684463292995c60fdde12cdac889de551d8f85b89e6b77416c" => :sierra
    sha256 "87507a739f2bd5ba57ccd23b34f2b7c41d68a897c128231dbbc32ba23b869ed5" => :el_capitan
    sha256 "813ccd28b00f94e1574079f7f6816858e32c5d8f9a964b783307d25c7e449d2b" => :yosemite
    sha256 "169598a0d41382215ba51ed0c377c98857804e82fb1658414dd04ee94ddbb993" => :mavericks
  end

  conflicts_with "crush-tools", :because => "both install an `aggregate` binary"

  def install
    bin.mkpath
    man1.mkpath

    # Makefile doesn't respect --mandir or MANDIR
    inreplace "Makefile.in", "$(prefix)/man/man1", "$(prefix)/share/man/man1"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    # Test case taken from here: http://horms.net/projects/aggregate/examples.shtml
    test_input = <<-EOS.undent
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/24
      10.1.1.0/24
      10.1.2.0/24
      10.1.2.0/25
      10.1.2.128/25
      10.1.3.0/25
    EOS

    expected_output = <<-EOS.undent
      10.0.0.0/19
      10.0.255.0/24
      10.1.0.0/23
      10.1.2.0/24
      10.1.3.0/25
    EOS

    assert_equal expected_output, pipe_output("#{bin}/aggregate", test_input), "Test Failed"
  end
end
