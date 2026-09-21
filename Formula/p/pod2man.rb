class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-v6.1.1.tar.xz"
  sha256 "a28027ac17848912ab2b14544fd457e28269e7b3f8423d72526556f9779b1807"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d208af3aedeb2139a4f1580f4115266e27849058c5aff53be2af97a98a8863c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d208af3aedeb2139a4f1580f4115266e27849058c5aff53be2af97a98a8863c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d208af3aedeb2139a4f1580f4115266e27849058c5aff53be2af97a98a8863c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3d208af3aedeb2139a4f1580f4115266e27849058c5aff53be2af97a98a8863c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "10f3eae739afacfc36189ddf27a9c44b68f7debffe082588169796060cc762c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6e10d72fb170c0c3863547e2d62c549b48a5cc4fedafb5ff97a2fac7b246f923"
  end

  keg_only "it conflicts with the pod2man that ships with Perl"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.48.tar.gz"
    sha256 "3297cf3c078de9d8297942423ec6ab59e85e30dfb38b782242699e386727c63a"
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
    assert_match "Pod::Man v#{version}", manpage
  end
end
