class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.0.tar.xz"
  sha256 "b17a598fbf58729ef13b577465eb93b2d484df1201518b708b5044ff623bf46d"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e204d69b16c02c6c27b37a0e06d35bcefc01a1bfce8a57e721aa54041061da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e204d69b16c02c6c27b37a0e06d35bcefc01a1bfce8a57e721aa54041061da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29064774e32e0385263a5da813bdf77fca59e206a391b18e2917c643d9bd79ae"
    sha256 cellar: :any_skip_relocation, ventura:        "83e204d69b16c02c6c27b37a0e06d35bcefc01a1bfce8a57e721aa54041061da"
    sha256 cellar: :any_skip_relocation, monterey:       "83e204d69b16c02c6c27b37a0e06d35bcefc01a1bfce8a57e721aa54041061da"
    sha256 cellar: :any_skip_relocation, big_sur:        "29064774e32e0385263a5da813bdf77fca59e206a391b18e2917c643d9bd79ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f29705aa9dc8df4dd45f0297712b193223d89cb918931fd16080d499b01598f1"
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
