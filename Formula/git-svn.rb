class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.0.tar.xz"
  sha256 "ba199b13fb5a99ca3dec917b0bd736bc0eb5a9df87737d435eddfdf10d69265b"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e2f6c751f93e8cb007d889eae2e1cf156cd1195af6046b9cabb9e8a41f6c5fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e2f6c751f93e8cb007d889eae2e1cf156cd1195af6046b9cabb9e8a41f6c5fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cccaf31188f75cdb736acf58adc4c183d1dfef968800116a702486be3a46f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "4e2f6c751f93e8cb007d889eae2e1cf156cd1195af6046b9cabb9e8a41f6c5fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4e2f6c751f93e8cb007d889eae2e1cf156cd1195af6046b9cabb9e8a41f6c5fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cccaf31188f75cdb736acf58adc4c183d1dfef968800116a702486be3a46f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9438d0de3560e0050740bf4d3a55d8e522399a82f3ac6f503248efe8b1480d30"
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
