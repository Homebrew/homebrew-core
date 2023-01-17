class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.39.1.tar.xz"
  sha256 "40a38a0847b30c371b35873b3afcf123885dd41ea3ecbbf510efa97f3ce5c161"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f14a645d2f7b32218d6efc14c164f3163ade1111eebfc558c36b647e81f7c643"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f14a645d2f7b32218d6efc14c164f3163ade1111eebfc558c36b647e81f7c643"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adb1a83e935a13b9a635a4317eb59bee37e2c4988490d0ec64d76747303bcbbc"
    sha256 cellar: :any_skip_relocation, ventura:        "f14a645d2f7b32218d6efc14c164f3163ade1111eebfc558c36b647e81f7c643"
    sha256 cellar: :any_skip_relocation, monterey:       "f14a645d2f7b32218d6efc14c164f3163ade1111eebfc558c36b647e81f7c643"
    sha256 cellar: :any_skip_relocation, big_sur:        "adb1a83e935a13b9a635a4317eb59bee37e2c4988490d0ec64d76747303bcbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2170d7e3a9b7b25626fbdd3e4cbc1c72d5b222bd0337334976ee841423f50c82"
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
