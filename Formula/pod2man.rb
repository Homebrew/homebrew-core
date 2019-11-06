class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.12.tar.xz"
  sha256 "d345ab7a68df69cb0f34299c385c0d0daefc00580f7cb4f6cb9c1e31549d04ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "b10053c393cabebef964e8b90dac619e19317f5bb35eb1b3be35c8244248540c" => :catalina
    sha256 "ed36edc4949a7487f04ee78b158c717e52201a697047285cc3ac3cb8f66688b6" => :mojave
    sha256 "7ec281093812bd9cfe65b774bed8831b615fcb309f04810e70b726321119e562" => :high_sierra
    sha256 "fd37f0663f60e32c126772b3c37f52ca101938b69c2ebd5182af61b64a18118b" => :sierra
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
