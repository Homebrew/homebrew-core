class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.2.tar.xz"
  sha256 "f612c1abc63557d50ad3849863fc9109670139fc9901e574460ec76e0511adb9"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65881b173ba14e27c57a6e9209fa0dc7f067c4cd2f614282891c8613f9987707"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "196d983238044f01109b88f1ca9d4d28d0f9a1cd3e3773eeb5dd17d05cd2c3dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "196d983238044f01109b88f1ca9d4d28d0f9a1cd3e3773eeb5dd17d05cd2c3dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "65881b173ba14e27c57a6e9209fa0dc7f067c4cd2f614282891c8613f9987707"
    sha256 cellar: :any_skip_relocation, ventura:        "196d983238044f01109b88f1ca9d4d28d0f9a1cd3e3773eeb5dd17d05cd2c3dc"
    sha256 cellar: :any_skip_relocation, monterey:       "196d983238044f01109b88f1ca9d4d28d0f9a1cd3e3773eeb5dd17d05cd2c3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658c13ea35c9adadd68038fd609e427d43c43b7c7984c0b1867eb18e7cce0463"
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
