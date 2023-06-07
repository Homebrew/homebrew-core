class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.41.0.tar.xz"
  sha256 "e748bafd424cfe80b212cbc6f1bbccc3a47d4862fb1eb7988877750478568040"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2217fe3417190af351967e51ea67fd8d1c2d4b2a50d5cc974853ca580c6dd40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2217fe3417190af351967e51ea67fd8d1c2d4b2a50d5cc974853ca580c6dd40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71b4f5bff617045470fb2068179513f1250035792a85bdd495e0ad402a44972f"
    sha256 cellar: :any_skip_relocation, ventura:        "d2217fe3417190af351967e51ea67fd8d1c2d4b2a50d5cc974853ca580c6dd40"
    sha256 cellar: :any_skip_relocation, monterey:       "d2217fe3417190af351967e51ea67fd8d1c2d4b2a50d5cc974853ca580c6dd40"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b4f5bff617045470fb2068179513f1250035792a85bdd495e0ad402a44972f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8b9a85c96c0323bea03f9140c0f1f1f8abc6ce52efb425c53ddb9a1796f940"
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
