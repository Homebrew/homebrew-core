class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.2.tar.xz"
  sha256 "c73d0c4fa5dcebdb2ccc293900952351cc5fb89224bb133c116305f45ae600f3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffb9a9584e6b66e30bbc288dfc412b6f8c46f5815e66d3fdd23b1762a309994f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f17426e00f18d68e13af5b0cfa2dbdb892dfe19e9842aac8f56df8e2865d20"
    sha256 cellar: :any_skip_relocation, monterey:       "ffb9a9584e6b66e30bbc288dfc412b6f8c46f5815e66d3fdd23b1762a309994f"
    sha256 cellar: :any_skip_relocation, big_sur:        "08f17426e00f18d68e13af5b0cfa2dbdb892dfe19e9842aac8f56df8e2865d20"
    sha256 cellar: :any_skip_relocation, catalina:       "97857a04d47b121734e7bc371c51111eb28bc2434be2e488f91234265d63710f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e89181032063f9aa5c3ad0e28de6f0cd8d0e1348351531c64061134c6df4bf85"
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
