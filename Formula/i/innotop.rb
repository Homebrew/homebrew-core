class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://github.com/innotop/innotop/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "45645f20e70d54adc5208b5098beb378f5f29fc5e0447237351311418cc9933b"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "https://github.com/innotop/innotop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f30a13ed3194557816cbc8be5a8449079346cb98977f8ce7b24d5c1dc3fa544c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f30a13ed3194557816cbc8be5a8449079346cb98977f8ce7b24d5c1dc3fa544c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30a13ed3194557816cbc8be5a8449079346cb98977f8ce7b24d5c1dc3fa544c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30a13ed3194557816cbc8be5a8449079346cb98977f8ce7b24d5c1dc3fa544c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61058c8a1eaf372375401dc6514c8ce0de39126104dfd8c4dabe68a029c5b215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ddbaf6f86f44a0fbeef939e5ce3e24986e987d7c63932414fb3fb9488868296"
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
