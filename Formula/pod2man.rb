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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e6c0e470b8138e4c14d74072a2a2fd18e6a1fd2cf5de274cbb6883b5e74c20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e6c0e470b8138e4c14d74072a2a2fd18e6a1fd2cf5de274cbb6883b5e74c20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acfffaf34dca9ea5dabfc050f169fc1448361c0177cf80c97a6930dddd785789"
    sha256 cellar: :any_skip_relocation, ventura:        "90cd0485e9d729fb4064e7e470c098e8a781d833d999a9b5ef7624106005f40d"
    sha256 cellar: :any_skip_relocation, monterey:       "90cd0485e9d729fb4064e7e470c098e8a781d833d999a9b5ef7624106005f40d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8e5c75883dca82a09d5c38e211a0e28f7a427d575de78a59093249b8fed53d4"
    sha256 cellar: :any_skip_relocation, catalina:       "0e3dbd2c66fde6944e6493ca208720d45c55fe79ae271fb3dbc63e96f19871a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59fe8c67d225d8f1761783c2981fe0637045963897230875120f31fa01f0f155"
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
