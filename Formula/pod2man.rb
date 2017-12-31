class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.10.tar.xz"
  sha256 "fe2f03ede570af7e9878e7d48757986ca13e978991901e4499df8fc6433836a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d9608def9daa2bb795a56e5df80043d63eb008175718d990df9aff58ece80bd" => :high_sierra
    sha256 "2cf1dfe0b8b253e9512510a4d8ff6b978e9eafdd9385c3f2b798786c29fbf32e" => :sierra
    sha256 "d2e5d9ea75def3862ed5a22c17054b59c7be71e33795a1335e760f6674f64260" => :el_capitan
    sha256 "87c97323caaad4ff681c76cd00f18b0575615f9e5bdf01b6dae20bba5d95ae74" => :yosemite
  end

  keg_only :provided_by_osx

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                   "INSTALLSCRIPT=#{bin}",
                   "INSTALLMAN1DIR=#{man1}", "INSTALLMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
  end
end
