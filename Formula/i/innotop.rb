class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "45645f20e70d54adc5208b5098beb378f5f29fc5e0447237351311418cc9933b"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 1
  head "https://github.com/innotop/innotop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd276aa717dcc08d7d939494fac97a1a1f84e305a2a9c60e70a8b670eae35fae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd276aa717dcc08d7d939494fac97a1a1f84e305a2a9c60e70a8b670eae35fae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd276aa717dcc08d7d939494fac97a1a1f84e305a2a9c60e70a8b670eae35fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd276aa717dcc08d7d939494fac97a1a1f84e305a2a9c60e70a8b670eae35fae"
    sha256 cellar: :any,                 arm64_linux:   "5d3ec8dc520eca1171bbc01271edbe16b2a16d2777071e4464c9d4a25c0caca2"
    sha256 cellar: :any,                 x86_64_linux:  "114d95b95a6cf07f722d2c8f2446d7472d0d736ba36f4548574d7131c24d47ee"
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
    ENV.prepend_path "PERL5LIB", formula_opt_libexec("perl-dbd-mysql")/"lib/perl5"
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
