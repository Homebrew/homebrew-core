class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.2.tar.xz"
  sha256 "475f75f1373b2cd4e438706185175966d5c11f68c4db1e48c26257c43ddcf2d6"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "586496be87f1a1ad17ae14a4ac93725856c97480a4200fce73c347e770b6143f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "586496be87f1a1ad17ae14a4ac93725856c97480a4200fce73c347e770b6143f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16145663a90108b47b3966736cd35219d93b63f6f39a45ad68b93bf263ab0d23"
    sha256 cellar: :any_skip_relocation, ventura:        "586496be87f1a1ad17ae14a4ac93725856c97480a4200fce73c347e770b6143f"
    sha256 cellar: :any_skip_relocation, monterey:       "586496be87f1a1ad17ae14a4ac93725856c97480a4200fce73c347e770b6143f"
    sha256 cellar: :any_skip_relocation, big_sur:        "16145663a90108b47b3966736cd35219d93b63f6f39a45ad68b93bf263ab0d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c494f6b9bcc2a71b891fa21b5faeea67a044a969210e807aafa41da08fc29c"
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
