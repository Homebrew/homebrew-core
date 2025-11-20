class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "cfedf31ba5617a5d53ff0fedc86a8578f805093705a5e96a5571d86f2d8457c0"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/innotop/innotop.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b44c7861957b9ff6ce395e4232c5d21944d6493e972e5d5dc2f205de0acc644d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954079748cf6e9ff2ed6cf2f1c32596c923dcc1b91e5731eda1b99c58644d239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954079748cf6e9ff2ed6cf2f1c32596c923dcc1b91e5731eda1b99c58644d239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d857ac77497c1ee6be53254808fb73c50f6906270d7c9d0480a69181375233f"
    sha256 cellar: :any_skip_relocation, sonoma:        "954079748cf6e9ff2ed6cf2f1c32596c923dcc1b91e5731eda1b99c58644d239"
    sha256 cellar: :any_skip_relocation, ventura:       "1d857ac77497c1ee6be53254808fb73c50f6906270d7c9d0480a69181375233f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87b81323270bd39ae2d5b41b93f84b766d47afc5145416f97e7247460b26dab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b9d968176edd6d7ef594c1e0b8ba4cd349999aa9b7e4c6161f30f8d0ce8157"
  end

  depends_on "perl-dbd-mysql"

  uses_from_macos "perl"

  resource "Term::ReadKey" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-dbd-mysql"].opt_libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLMAN1DIR=none", "INSTALLMAN3DIR=none"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
