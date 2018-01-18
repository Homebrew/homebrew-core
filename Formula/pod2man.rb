class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.10.tar.xz"
  sha256 "fe2f03ede570af7e9878e7d48757986ca13e978991901e4499df8fc6433836a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e92e6b707bc43455372737a425e346a85ef58f02d0f1ba1f9aa3c5a39342e8aa" => :high_sierra
    sha256 "d14e362b3cd8f1f5b3b949ba80c260e67a7263db05b55aa6917e8d078768fd72" => :sierra
    sha256 "a1d9b068b86149457b8c99e473ed880120b456826341d540854ffc116d301ead" => :el_capitan
  end

  keg_only :provided_by_macos

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
