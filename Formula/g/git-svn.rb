class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.56.1.tar.xz"
  sha256 "f0b0bf89264b9bd2e1c640363e7529643989da76281600473c50745cd34a607f"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2873553993805a93f82518d11632eef95992d885b93408da33303d653795bea7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2873553993805a93f82518d11632eef95992d885b93408da33303d653795bea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2873553993805a93f82518d11632eef95992d885b93408da33303d653795bea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78f68cd6e751aefed14c28b7d9f1db1394504f781e0c0a7b5ea814de6f06087a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "797172f1ce13af4e6fd58ee932203267da022992ae710f1c48a516d9569fbae4"
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
