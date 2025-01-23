class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.48.1.tar.xz"
  sha256 "1c5d545f5dc1eb51e95d2c50d98fdf88b1a36ba1fa30e9ae5d5385c6024f82ad"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8945f482dda309468e921266bb80a9418602d43aac686f842621dfb47b8348d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8945f482dda309468e921266bb80a9418602d43aac686f842621dfb47b8348d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4de67e0698cd8f91e7edb5899d6f1a15b761897fed1b931a3848093069b09d60"
    sha256 cellar: :any_skip_relocation, sonoma:        "8945f482dda309468e921266bb80a9418602d43aac686f842621dfb47b8348d7"
    sha256 cellar: :any_skip_relocation, ventura:       "4de67e0698cd8f91e7edb5899d6f1a15b761897fed1b931a3848093069b09d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b495bebe6a4b5f0bd571a09f0e2ba16849f669bfd11704e83df69ba781a2baa"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    subversion = Formula["subversion"]
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "x86_64-linux-thread-multi"
    ENV["PERLLIB_EXTRA"] = subversion.opt_lib/"perl5/site_perl"/perl_version/os_tag
    if OS.mac?
      ENV["PERLLIB_EXTRA"] += ":" + %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_short_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    args = %W[
      prefix=#{prefix}
      perllibdir=#{Formula["git"].opt_share}/perl5
      SCRIPT_PERL=git-svn.perl
    ]

    mkdir libexec/"git-core"
    system "make", "install-perl-script", *args

    bin.install_symlink libexec/"git-core/git-svn"
  end

  test do
    system "svnadmin", "create", "repo"

    url = "file://#{testpath}/repo"
    text = "I am the text."
    log = "Initial commit"

    system "svn", "checkout", url, "svn-work"
    (testpath/"svn-work").cd do |current|
      (current/"text").write text
      system "svn", "add", "text"
      system "svn", "commit", "-m", log
    end

    system "git", "svn", "clone", url, "git-work"
    (testpath/"git-work").cd do |current|
      assert_equal text, (current/"text").read
      assert_match log, pipe_output("git log --oneline")
    end
  end
end
