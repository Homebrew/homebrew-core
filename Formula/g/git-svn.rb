class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.47.0.tar.xz"
  sha256 "1ce114da88704271b43e027c51e04d9399f8c88e9ef7542dae7aebae7d87bc4e"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd65bda4427e47fde40e1229a9431b681cb09cf76ed1c35c504b701012ab6e5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd65bda4427e47fde40e1229a9431b681cb09cf76ed1c35c504b701012ab6e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfc65ca45bed1028465e6d7af7e2bfeaab26771776f802125a7dd3c59d542e95"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd65bda4427e47fde40e1229a9431b681cb09cf76ed1c35c504b701012ab6e5c"
    sha256 cellar: :any_skip_relocation, ventura:       "bfc65ca45bed1028465e6d7af7e2bfeaab26771776f802125a7dd3c59d542e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f82f3ee3f9186baaa5229a63a7970e6269d3f92778f849a4505f74dbf99bb120"
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
