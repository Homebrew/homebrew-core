class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.50.1.tar.xz"
  sha256 "7e3e6c36decbd8f1eedd14d42db6674be03671c2204864befa2a41756c5c8fc4"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9443c387440b428a519dc695000202aeab8d83eb61b76dcddee3021850827735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9443c387440b428a519dc695000202aeab8d83eb61b76dcddee3021850827735"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dcec6b1bfacf4ed7d6f2d5b91045ce60f053d8692fc7ab09cb9e35c39ad25dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9443c387440b428a519dc695000202aeab8d83eb61b76dcddee3021850827735"
    sha256 cellar: :any_skip_relocation, ventura:       "9dcec6b1bfacf4ed7d6f2d5b91045ce60f053d8692fc7ab09cb9e35c39ad25dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bebb4d1896330e3cde23849c68c3fee44c57cb481188f630987cee55c39c3364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12fcfe012c9a597a64c4a14e4c284b0ec386cc643238bd9581a50c1b970ae698"
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
    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch
    os_tag = OS.mac? ? "darwin-thread-multi-2level" : "#{arch}-linux-thread-multi"
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
