class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https://github.com/miyagawa/cpanminus"
  # Don't use git tags, their naming is misleading
  url "https://cpan.metacpan.org/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7047.tar.gz"
  sha256 "963e63c6e1a8725ff2f624e9086396ae150db51dd0a337c3781d09a994af05a5"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  version_scheme 1

  head "https://github.com/miyagawa/cpanminus.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "37fb79c294b47339574f139986229bc14bf812b7b59a010ed139b13ab2390010"
  end

  depends_on "perl" => :build

  def install
    cd "App-cpanminus" if build.head?

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    inreplace_files = [
      buildpath/"README",
      bin/"cpanm",
      lib/"perl5/App/cpanminus/fatscript.pm",
      lib/"perl5/App/cpanminus.pm",
      man3/"App::cpanminus.3",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, audit_result: build.stable?

    # Needed for dependents that might use Homebrew perl or system perl.
    inreplace bin/"cpanm", %r{^#!#{Regexp.escape(Formula["perl"].opt_bin)}/perl$}, "#!/usr/bin/env perl"
  end

  test do
    assert_match "cpan.metacpan.org", stable.url, "Don't use git tags, their naming is misleading"
    system bin/"cpanm", "--local-lib=#{testpath}/perl5", "Test::More"
  end
end
