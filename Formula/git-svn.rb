class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.xz"
  sha256 "405d4a0ff6e818d1f12b3e92e1ac060f612adcb454f6299f70583058cb508370"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4439f0fc815c8e78890b834bb0ff16d62e6a12d0db05b61246e8bd6177abbd99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44b77270a526ddbf3d12cb28fee7b03c0ee12a2659d3ac0d017fe811af4a821d"
    sha256 cellar: :any_skip_relocation, monterey:       "4439f0fc815c8e78890b834bb0ff16d62e6a12d0db05b61246e8bd6177abbd99"
    sha256 cellar: :any_skip_relocation, big_sur:        "44b77270a526ddbf3d12cb28fee7b03c0ee12a2659d3ac0d017fe811af4a821d"
    sha256 cellar: :any_skip_relocation, catalina:       "ec8ab1486a32e4b0df9e99f1b10492043b52c0e605bfd3c7a61c7cd64ac76dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e237b2d8803fd19f082f34a2c35a2db86a9f7adfbdc2413e4ade4f711511d122"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    ENV["PERLLIB_EXTRA"] = Formula["subversion"].opt_lib/"perl5/site_perl"/perl_version/"darwin-thread-multi-2level"
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
