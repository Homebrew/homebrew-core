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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c5247c23c7441d746207c85b3e2f76f83c4149fcc4ad3bdefa5e41f609820fca"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5247c23c7441d746207c85b3e2f76f83c4149fcc4ad3bdefa5e41f609820fca"
    sha256 cellar: :any_skip_relocation, catalina:      "6a46194855951dff9cd5040fb70725947b65a1433868d6fda21fcc6262b598ae"
    sha256 cellar: :any_skip_relocation, mojave:        "6a46194855951dff9cd5040fb70725947b65a1433868d6fda21fcc6262b598ae"
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
