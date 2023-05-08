class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.40.1.tar.xz"
  sha256 "4893b8b98eefc9fdc4b0e7ca249e340004faa7804a433d17429e311e1fef21d2"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a62f98eac3f48e38af71a94c408af8ece80eae75fa5bfe8523b3bbd699a4286e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a62f98eac3f48e38af71a94c408af8ece80eae75fa5bfe8523b3bbd699a4286e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8b59f7430095ef9cfce050a681a2720dba1623bd0d9bd3a1accfa170df5177"
    sha256 cellar: :any_skip_relocation, ventura:        "a62f98eac3f48e38af71a94c408af8ece80eae75fa5bfe8523b3bbd699a4286e"
    sha256 cellar: :any_skip_relocation, monterey:       "a62f98eac3f48e38af71a94c408af8ece80eae75fa5bfe8523b3bbd699a4286e"
    sha256 cellar: :any_skip_relocation, big_sur:        "be8b59f7430095ef9cfce050a681a2720dba1623bd0d9bd3a1accfa170df5177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddfcc7e266b7e91cd6385a17ad199f49b45609d212950cc3220e44b337c5e450"
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
