class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.49.0.tar.xz"
  sha256 "618190cf590b7e9f6c11f91f23b1d267cd98c3ab33b850416d8758f8b5a85628"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f312449a9465a70cf2e7035595d0fb32b3a9e157422686bc1fbf78bc51e8414a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f312449a9465a70cf2e7035595d0fb32b3a9e157422686bc1fbf78bc51e8414a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f0b46ef5545624e251e43c5df1c137baead54d150040b7a5926ab38b33de01e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f312449a9465a70cf2e7035595d0fb32b3a9e157422686bc1fbf78bc51e8414a"
    sha256 cellar: :any_skip_relocation, ventura:       "5f0b46ef5545624e251e43c5df1c137baead54d150040b7a5926ab38b33de01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c0d54ed05e10e00efbfab2034f6d763caaa444cf299889458bd40a58486f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4171242e63d0d72ffcccf80596cd38b3fe8858083382504099cf81538378e0da"
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
