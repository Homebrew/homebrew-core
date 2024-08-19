class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.46.0.tar.xz"
  sha256 "7f123462a28b7ca3ebe2607485f7168554c2b10dfc155c7ec46300666ac27f95"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccbb434bfa985e1e90ba0ff080bdf21aee00e573bdd133a545b5714675ddb78f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90182fc6f9393993fc4ad2efca3380c6ea3908741f7a0126e60d110119847565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90182fc6f9393993fc4ad2efca3380c6ea3908741f7a0126e60d110119847565"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccbb434bfa985e1e90ba0ff080bdf21aee00e573bdd133a545b5714675ddb78f"
    sha256 cellar: :any_skip_relocation, ventura:        "90182fc6f9393993fc4ad2efca3380c6ea3908741f7a0126e60d110119847565"
    sha256 cellar: :any_skip_relocation, monterey:       "90182fc6f9393993fc4ad2efca3380c6ea3908741f7a0126e60d110119847565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e8424cb9bed4c57bc15640060d9451ae4793b8de86921288d13a79a795f2ceb"
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
