class Pod2man < Formula
  desc "Perl documentation generator"
  homepage "https://www.eyrie.org/~eagle/software/podlators/"
  url "https://archives.eyrie.org/software/perl/podlators-v6.1.0.tar.xz"
  sha256 "6eb43a0fc8381969d5910f8c46ea11e8867e0862ff3c8a1ccda109894cb7de34"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://archives.eyrie.org/software/perl/"
    regex(/href=.*?podlators[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72f1352cd5fdf744fe9ceea9b3e5bc54bf57bc21f38675b563a23c6756b5dab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72f1352cd5fdf744fe9ceea9b3e5bc54bf57bc21f38675b563a23c6756b5dab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72f1352cd5fdf744fe9ceea9b3e5bc54bf57bc21f38675b563a23c6756b5dab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c4d114fd203bdb437dafd54d3c9582d020ace5f9351b08076da0582ac922e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "106e94c77fc46f089b21b704f5bc173c583a2b18bece4997fb58a897b2e19d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839cea97df94dfacac278c9bd5a99986c0aa99d119f018395b28bda572b066c1"
  end

  keg_only "it conflicts with the pod2man that ships with Perl"

  resource "Pod::Simple" do
    url "https://cpan.metacpan.org/authors/id/K/KH/KHW/Pod-Simple-3.45.tar.gz"
    sha256 "8483bb95cd3e4307d66def092a3779f843af772482bfdc024e3e00d0c4db0cfa"
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
