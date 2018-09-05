class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.11.tar.xz"
  sha256 "4c08c5dd08c63831ac2fa5a18ee0c9e55a178db7bb145be89fe71ef8e9d8d91d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e444c6b55bc4943f4508a3f9f8d5999895f6f0242216c53854c55998156102" => :mojave
    sha256 "6c780c4466590c859810bda4c1e851f3d36bd6b053302cef045ddcfb94a0d964" => :high_sierra
    sha256 "94d9f00a8c1226b62a0d3d729770eb4e9a8be0a51a3e60ef7dd466152710bbe0" => :sierra
    sha256 "54894e5d48ada5a3746777469f95b7ab83d59f409812d4cf48284ab2a8bb14fb" => :el_capitan
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
