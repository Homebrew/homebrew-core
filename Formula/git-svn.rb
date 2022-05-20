class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.xz"
  sha256 "405d4a0ff6e818d1f12b3e92e1ac060f612adcb454f6299f70583058cb508370"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9c92a602a9038f3876c93acedd436a2d880ed037b2e3b0eefb9ba891584d853"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2bd8ca50a71ae14b96a96f6042a5163db53c3cac805df690902048a1dcf0142"
    sha256 cellar: :any_skip_relocation, monterey:       "a9c92a602a9038f3876c93acedd436a2d880ed037b2e3b0eefb9ba891584d853"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2bd8ca50a71ae14b96a96f6042a5163db53c3cac805df690902048a1dcf0142"
    sha256 cellar: :any_skip_relocation, catalina:       "447710705737995382789cc973954c1b16771a52e35971a0511548fd167d808e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f2c906f05d9f4aad36ccbd83b8008f325c4d2650a07c23270285e84eee21d7"
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
