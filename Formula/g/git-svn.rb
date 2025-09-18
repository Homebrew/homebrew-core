class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.0.tar.xz"
  sha256 "60a7c2251cc2e588d5cd87bae567260617c6de0c22dca9cdbfc4c7d2b8990b62"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c817b0e608d2d4670a4a78ca4a96752c82f066ad4c6cac6be62d6960fe355241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c817b0e608d2d4670a4a78ca4a96752c82f066ad4c6cac6be62d6960fe355241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c817b0e608d2d4670a4a78ca4a96752c82f066ad4c6cac6be62d6960fe355241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b037f3f20d5db0fae8984b530b8471ec13c3c611746f60a988eea4fb075a8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c817b0e608d2d4670a4a78ca4a96752c82f066ad4c6cac6be62d6960fe355241"
    sha256 cellar: :any_skip_relocation, ventura:       "3b037f3f20d5db0fae8984b530b8471ec13c3c611746f60a988eea4fb075a8e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f427e916b44b21afc4c6be8cfb912732ceb5c93b8b14c41f6abab666ac0c414e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "081eb656093bd198429dcf9e7eed8fdb12274cae06ee9ce3c3585cfd2fe34925"
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
