class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.0.tar.xz"
  sha256 "923eade26b1814de78d06bda8e0a9f5da8b7c4b304b3f9050ffb464f0310320a"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eae15622b471185a82cb0efcbddd2c2d642c693278979ae8b40f4e13bccc01b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1367e761103c33c03cad695dd2a973b95afe3cf68c39e4a4bf644922f4b3c83"
    sha256 cellar: :any_skip_relocation, monterey:       "eae15622b471185a82cb0efcbddd2c2d642c693278979ae8b40f4e13bccc01b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1367e761103c33c03cad695dd2a973b95afe3cf68c39e4a4bf644922f4b3c83"
    sha256 cellar: :any_skip_relocation, catalina:       "954790646b3d254944273ca13753cd492b98b867e232ee4275fbf4db370ad8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2252d2df68933fc91586d29a55d707b54eb6ae5aee68262e79c856abd81287db"
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
