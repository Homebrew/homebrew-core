class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  # Don't use git tags, their naming is misleading
  url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7046.tar.gz"
  sha256 "3e8c9d9b44a7348f9acc917163dbfc15bd5ea72501492cea3a35b346440ff862"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  version_scheme 1

  head "https://github.com/miyagawa/cpanminus.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c279cbdfa489e4b0be72e46a8e325fc4f8070ff83c7d78026e7b7c5831e3678d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78c0fc8d2fcb14cb94e62d972f06ae6a1762846471eb5d0669909121c24fa08d"
    sha256 cellar: :any_skip_relocation, monterey:       "7859de46dbe67b3c9375bd8e3de6519d75f3c69a8d3698d3bb22d6163452ab39"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, catalina:       "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, mojave:         "6a9b5bde63d8c5860788c67470c9dffcfe12036d38e331ad4c5028455ad45a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c0fc8d2fcb14cb94e62d972f06ae6a1762846471eb5d0669909121c24fa08d"
  end

  uses_from_macos "perl"

  def install
    cd "App-cpanminus" if build.head?

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}",
                                                            "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"
  end

  test do
    assert_match "cpan.metacpan.org", stable.url, "Don't use git tags, their naming is misleading"
    system "#{bin}/cpanm", "--local-lib=#{testpath}/perl5", "Test::More"
  end
end
