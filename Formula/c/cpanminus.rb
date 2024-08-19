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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79c1c6d873f3ea1f5582da2544a9fcbaab6d1303d328b3877a70d63b9a355ca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79c1c6d873f3ea1f5582da2544a9fcbaab6d1303d328b3877a70d63b9a355ca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c1c6d873f3ea1f5582da2544a9fcbaab6d1303d328b3877a70d63b9a355ca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c89d41c3b87de4c87a36355ded72110aab1e13b18ab33e2ac50590906e0aac21"
    sha256 cellar: :any_skip_relocation, sonoma:         "f20737479b4b5d7d2945aa09b8b25e91d09205725b2a0a3858a37c1eeb282f92"
    sha256 cellar: :any_skip_relocation, ventura:        "f20737479b4b5d7d2945aa09b8b25e91d09205725b2a0a3858a37c1eeb282f92"
    sha256 cellar: :any_skip_relocation, monterey:       "f20737479b4b5d7d2945aa09b8b25e91d09205725b2a0a3858a37c1eeb282f92"
    sha256 cellar: :any_skip_relocation, big_sur:        "76af4606a249844bc3f2cc521c3948b4e4e78e022f8d5d676ada9bcc91f4307d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7901d4e2cf8cf79ccd841ec638bfd5450c14efc2abd07ef90ee024e954b93f6d"
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
    system bin/"cpanm", "--local-lib=#{testpath}/perl5", "Test::More"
  end
end
