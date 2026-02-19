class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "cfedf31ba5617a5d53ff0fedc86a8578f805093705a5e96a5571d86f2d8457c0"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "https://github.com/innotop/innotop.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f1f7200e8bc7f549dd1ac59d991d20fc90fefbd86e1aaa94e6c1106e02b651f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1f7200e8bc7f549dd1ac59d991d20fc90fefbd86e1aaa94e6c1106e02b651f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1f7200e8bc7f549dd1ac59d991d20fc90fefbd86e1aaa94e6c1106e02b651f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f1f7200e8bc7f549dd1ac59d991d20fc90fefbd86e1aaa94e6c1106e02b651f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f2878c0dbd65584c8a7d7c7a04a569412c1301654a02ecc227f1b509df65a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "994567fc14ad431d0d5e464dd59887da03c8ea478d712b24492c20f5a3b5c827"
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
