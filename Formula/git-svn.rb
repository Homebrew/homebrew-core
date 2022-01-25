class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.0.tar.xz"
  sha256 "47e677b475226857ceece569fb6ded8b85838ede97ae1e01bd365ac32a468fc8"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bccb74d3bfc27acb23e0fbc3e83f61cbfb410dbd37e7172cd43b66c262dcc87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46553c07e16ae80c0a95bb487cce4fb38c6905cde5b22e98a8fe4697c062a485"
    sha256 cellar: :any_skip_relocation, monterey:       "3bccb74d3bfc27acb23e0fbc3e83f61cbfb410dbd37e7172cd43b66c262dcc87"
    sha256 cellar: :any_skip_relocation, big_sur:        "46553c07e16ae80c0a95bb487cce4fb38c6905cde5b22e98a8fe4697c062a485"
    sha256 cellar: :any_skip_relocation, catalina:       "5ebbf6c8ab9289f69ccf0fe204d6e556eb9b5a56d9f79695358a1070a25a5304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30fb84d987cf326586359307ceaf4abb2f84000647be541a8e3b4b496d635418"
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
