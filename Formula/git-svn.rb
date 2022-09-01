class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.3.tar.xz"
  sha256 "814641d7f61659cfbc17825d0462499ca1403e39ff53d76a8512050e6483e87a"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7462ebae084fca838e81e26c73d35ba5339eb977b3edf923c3350039b584cf73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "657ecedffe99cbdcdd14c462009ebb8692ee72c5a9b94bbd4d1f5135d4c59b08"
    sha256 cellar: :any_skip_relocation, monterey:       "7462ebae084fca838e81e26c73d35ba5339eb977b3edf923c3350039b584cf73"
    sha256 cellar: :any_skip_relocation, big_sur:        "657ecedffe99cbdcdd14c462009ebb8692ee72c5a9b94bbd4d1f5135d4c59b08"
    sha256 cellar: :any_skip_relocation, catalina:       "416232f1f967e9ca0c22ce63ce0720a952381a0308ff785821e29d4e0f5b1c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d40b8598b71d2c45427faec9a8fc75daec830752f721272577389f7ad8c27e"
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
