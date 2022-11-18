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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50d18acee10ae2f75dea455e8b338b18f6e528002f81e97781535399e02e2eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a3cbb2a37c9229ee205c974d86c645dc5455da369a8b8ca3f6b8429cdea0676"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "164032cd2f4c0a185406dc9ab12e933c1b671b14b9c99a12d0c2c4b475043901"
    sha256 cellar: :any_skip_relocation, ventura:        "ab901b1645c97fa50ee52ecc4bf51bac7f8a8959abe664bbdd66c3d1a565d1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "9dc8b90204bc795116a839e16c1f4796355286bf6d8b0e3da01ef739dedb9748"
    sha256 cellar: :any_skip_relocation, big_sur:        "3663bd1fdc1ded95e73ec538b6a4f052f48c0e2f343fd232ba7500865bb5c793"
    sha256 cellar: :any_skip_relocation, catalina:       "4d47cf54e738c85d981baac0f29c949dfab4551eb27cc18da52c3144344ee7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792d60a253311201af088923aaebfa4dca8c2a8602c00c405ad543540f9764fd"
  end

  uses_from_macos "perl"

  def install
    cd "App-cpanminus" if build.head?

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"
  end

  def post_install
    cpanm_lines = (bin/"cpanm").read.lines
    return if cpanm_lines.first.match?(%r{^#!/usr/bin/env perl})

    ohai "Adding `/usr/bin/env perl` shebang to `cpanm`..."
    cpanm_lines.unshift "#!/usr/bin/env perl\n"
    (bin/"cpanm").atomic_write cpanm_lines.join
  end

  test do
    assert_match "cpan.metacpan.org", stable.url, "Don't use git tags, their naming is misleading"
    system "#{bin}/cpanm", "--local-lib=#{testpath}/perl5", "Test::More"
  end
end
