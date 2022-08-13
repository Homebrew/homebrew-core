class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.2.tar.xz"
  sha256 "1c3d9c821c4538e7a6dac30a4af8bd8dcfe4f651f95474c526b52f83406db003"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b09570bea89061ff64dfba7bb1c67836793ec6f44bfaefae91db7617202b558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cc2dc1b7fe57cea10c4678a26aa8a732cc90e56c530f1aca3242a5d27e102ff"
    sha256 cellar: :any_skip_relocation, monterey:       "8b09570bea89061ff64dfba7bb1c67836793ec6f44bfaefae91db7617202b558"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cc2dc1b7fe57cea10c4678a26aa8a732cc90e56c530f1aca3242a5d27e102ff"
    sha256 cellar: :any_skip_relocation, catalina:       "3b86e8c6c54a2c5753daad7e97e740fd0222b6e7445d66aba5857a0ac12e78b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d305c75375dbc25e537816f3433c7082d21750a8b3b5db394f4ce255465009b7"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    ENV["PERLLIB_EXTRA"] = Formula["subversion"].opt_lib/"perl5/site_perl"/perl_version/"darwin-thread-multi-2level"
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
