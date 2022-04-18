class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.0.tar.xz"
  sha256 "af5ebfc1658464f5d0d45a2bfd884c935fb607a10cc021d95bc80778861cc1d3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12630021ae0126f71d7de74d95312545f975ae6fd2723be229c23453569d503c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0b8b6e0d837541d55f62ee08ea27416653a695516438da11ffc7ea25cb70af7"
    sha256 cellar: :any_skip_relocation, monterey:       "12630021ae0126f71d7de74d95312545f975ae6fd2723be229c23453569d503c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b8b6e0d837541d55f62ee08ea27416653a695516438da11ffc7ea25cb70af7"
    sha256 cellar: :any_skip_relocation, catalina:       "5d414fd3b92808e8da5d3a1f408ac7fdf56e784fe61dcdace501e63d6769e80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5ffad6e5a0b251f36f3632c1ca49f852c53b5b91dd98f698e970ae88ed83ce"
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
