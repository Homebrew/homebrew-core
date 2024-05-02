class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-5.01.tar.xz"
  sha256 "76260ab7e2b343b38351dff42f576f9cd61166d1ff5cc8e15c0f79f28d518e77"

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68233590467cb5cb8e61d34d3a645d2078d0084f380c8aab92f40c61bf86e59c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fa74a3c4174f393da58ddf7d466629f1ebcb10c5b3f3ae8e50c676ffcc02e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa74a3c4174f393da58ddf7d466629f1ebcb10c5b3f3ae8e50c676ffcc02e2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d769fcfbea533598b2366b7c608e764f911034fc89237cd2c8d0656474e945d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "672dc6a92f4c386f245f7a64a12f39ced171d23c90842b8657b4b22226ad5ebb"
    sha256 cellar: :any_skip_relocation, ventura:        "efda90db8dd0b7a04fa853e7aed0045049c408eb3bf798d0248b63cee60851e6"
    sha256 cellar: :any_skip_relocation, monterey:       "efda90db8dd0b7a04fa853e7aed0045049c408eb3bf798d0248b63cee60851e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3709c2f1a523bfdc7666d7254062b6fe1a274b0bc1f1f33c07f0ca7a2b757f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ff87ced43f638d9aab682367e0654a6f12ce4653b82647c17a38b0f9b44aff"
  end

  keg_only "perl ships with pod2man"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.43.tar.gz"
    sha256 "65abe3f5363fa4cdc108f5ad9ce5ce91e7a39186a1b297bb7a06fa1b0f45d377"
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
