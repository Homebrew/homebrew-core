class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-4.14.tar.xz"
  sha256 "e504c3d9772b538d7ea31ce2c5e7a562d64a5b7f7c26277b1d7a0de1f6acfdf4"
  revision 3

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43be4d4635b4c90f5d5a9518229d45d6e9ef4956a16b8e41d373ae4ab88c6d83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342ed828eb46d48381a7a3273a1858cccb0818f893bf1c384508842c49864fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "ee09c8d2a8e36c1bd0e3532028f6603ae9fb8d6cd46882a903b12c41a90d5da0"
    sha256 cellar: :any_skip_relocation, big_sur:        "53e3c8c329177d03b2894745c6d679fa752f828daafaff0ef2bc10800b6dbcf5"
    sha256 cellar: :any_skip_relocation, catalina:       "ca1fb674f4d5ffd23945ec684b4ba2ca48241cb5e273fbd4b4007753277e2e4a"
    sha256 cellar: :any_skip_relocation, mojave:         "09c560e15e46d7eb4836ced38a0eea6900ddce5d5230a86578c33ed61328ce5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf311d7a284678c630a79a0c812b98288937291973742af5bca2712f8399548"
  end

  keg_only "perl ships with pod2man"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.42.tar.gz"
    sha256 "a9fceb2e0318e3786525e6bf205e3e143f0cf3622740819cab5f058e657e8ac5"
  end

  def install
    resource("Pod::Simple").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end
    ENV.prepend_path "PERL5LIB", libexec/"lib/perl5"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                   "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: "#{lib}/perl5:#{libexec}/lib/perl5"
  end

  test do
    (testpath/"test.pod").write "=head2 Test heading\n"
    manpage = shell_output("#{bin}/pod2man #{testpath}/test.pod")
    assert_match '.SS "Test heading"', manpage
    assert_match "Pod::Man #{version}", manpage
  end
end
