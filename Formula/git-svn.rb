class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.1.tar.xz"
  sha256 "c8162c6b8b8f1c5db706ab01b4ee29e31061182135dc27c4860224aaec1b3500"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fa424e83e1aec4d4aad004f5a5c5d10ffdf91298f7ad1d68e4bd99eafcfd610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7fdecfa825f5ae371fb59dacd67e42ae4dceeccaf4f0dee9bd7c6fa79026cd"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa424e83e1aec4d4aad004f5a5c5d10ffdf91298f7ad1d68e4bd99eafcfd610"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c7fdecfa825f5ae371fb59dacd67e42ae4dceeccaf4f0dee9bd7c6fa79026cd"
    sha256 cellar: :any_skip_relocation, catalina:       "071e9b164b0eaa1d302ce32ffeaa56e9c1158056f3bc7c96222f14ef71293681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87398f65a0449b1910797e577a9925147f9db3f334f8066931b756ed2ef5cb7f"
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
