class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.52.0.tar.xz"
  sha256 "3cd8fee86f69a949cb610fee8cd9264e6873d07fa58411f6060b3d62729ed7c5"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "003563f7eb62878dad881c29f7a8477468f04f1b49941ab6801c7f3ccd4ad58a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003563f7eb62878dad881c29f7a8477468f04f1b49941ab6801c7f3ccd4ad58a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003563f7eb62878dad881c29f7a8477468f04f1b49941ab6801c7f3ccd4ad58a"
    sha256 cellar: :any_skip_relocation, sonoma:        "003563f7eb62878dad881c29f7a8477468f04f1b49941ab6801c7f3ccd4ad58a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2e66c8ceead89240cc6d95c5591dc5fa1efe891eb5592e799ffb669281e9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ac9792f5f482a87865b5b17a6c70c870448a37790c3b86c887e53e80a04010"
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
