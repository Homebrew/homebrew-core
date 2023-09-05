class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.42.0.tar.xz"
  sha256 "3278210e9fd2994b8484dd7e3ddd9ea8b940ef52170cdb606daa94d887c93b0d"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804d5a3734ed28a8c7d00efc00d3a2e7ba4f7fa284f57f18d06f31baeea8757d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "804d5a3734ed28a8c7d00efc00d3a2e7ba4f7fa284f57f18d06f31baeea8757d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f0df16cc8e4eab8db8edfb71bb15b1330c47446636ea17fceca083323fb161c"
    sha256 cellar: :any_skip_relocation, ventura:        "804d5a3734ed28a8c7d00efc00d3a2e7ba4f7fa284f57f18d06f31baeea8757d"
    sha256 cellar: :any_skip_relocation, monterey:       "804d5a3734ed28a8c7d00efc00d3a2e7ba4f7fa284f57f18d06f31baeea8757d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f0df16cc8e4eab8db8edfb71bb15b1330c47446636ea17fceca083323fb161c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e12decd6fbfb85e5145e31399b28186b4777bf26753a7020d92bf324a3a511f"
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
