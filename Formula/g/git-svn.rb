class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz"
  sha256 "5818bd7d80b061bbbdfec8a433d609dc8818a05991f731ffc4a561e2ca18c653"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65169649154dcc5dc2ee43ee32b6073d307f63a014309416bb096cc811a12081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65169649154dcc5dc2ee43ee32b6073d307f63a014309416bb096cc811a12081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65169649154dcc5dc2ee43ee32b6073d307f63a014309416bb096cc811a12081"
    sha256 cellar: :any_skip_relocation, sonoma:        "65169649154dcc5dc2ee43ee32b6073d307f63a014309416bb096cc811a12081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b908775e95be7e4108cf1637f241b3d5d6063155e825d5434780ef938ecca075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4591b4de99d5d4ee0ad984800a5eed4fce477ba5c92cb1a0e379ee5ac38a763"
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
