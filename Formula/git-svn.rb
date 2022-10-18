class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.xz"
  sha256 "97ddf8ea58a2b9e0fbc2508e245028ca75911bd38d1551616b148c1aa5740ad9"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9a135941d976d808695681833a981dd764dcb7327a4d46542c1b921b3570f14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c3ee881ac97776d125aa214737b8ce55cdfca7e5b6128653e575a5e94ab65d0"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a135941d976d808695681833a981dd764dcb7327a4d46542c1b921b3570f14"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c3ee881ac97776d125aa214737b8ce55cdfca7e5b6128653e575a5e94ab65d0"
    sha256 cellar: :any_skip_relocation, catalina:       "e9936d5a54fba1620b17268f6e23bbd4a9436ceb8d2aab2ee48667268f37225b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3b32d8c9faaf0ce0316c0ba7264a2dbec0a5c4a5d8d98f0628f0b210cab6944"
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
