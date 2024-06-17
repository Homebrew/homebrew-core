class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.2.tar.xz"
  sha256 "51bfe87eb1c02fed1484051875365eeab229831d30d0cec5d89a14f9e40e9adb"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ff9be6e0f9d496046da6c461e152a57c548b5f5a06c491fbecf18e146bcf0c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed76d079dc87cacc3e1bedf3618d36742fd28585982ddcd8fd2563d12622cc9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed76d079dc87cacc3e1bedf3618d36742fd28585982ddcd8fd2563d12622cc9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff9be6e0f9d496046da6c461e152a57c548b5f5a06c491fbecf18e146bcf0c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ed76d079dc87cacc3e1bedf3618d36742fd28585982ddcd8fd2563d12622cc9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed76d079dc87cacc3e1bedf3618d36742fd28585982ddcd8fd2563d12622cc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0927323cad5e61a6d962597268a59aeff2e0b6910aa6d9c47d01f5c69336a5"
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
