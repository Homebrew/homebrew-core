class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.44.0.tar.xz"
  sha256 "e358738dcb5b5ea340ce900a0015c03ae86e804e7ff64e47aa4631ddee681de3"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3362f4e12e26a6e9c8cdabda4cea74aac8b044ffd33372679e0d9d5d53c6f37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e3d10cf897e8f385abcc0dc08e2f0f3f2849f42e72dd411d26f08cf186e72d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e3d10cf897e8f385abcc0dc08e2f0f3f2849f42e72dd411d26f08cf186e72d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3362f4e12e26a6e9c8cdabda4cea74aac8b044ffd33372679e0d9d5d53c6f37e"
    sha256 cellar: :any_skip_relocation, ventura:        "5e3d10cf897e8f385abcc0dc08e2f0f3f2849f42e72dd411d26f08cf186e72d5"
    sha256 cellar: :any_skip_relocation, monterey:       "5e3d10cf897e8f385abcc0dc08e2f0f3f2849f42e72dd411d26f08cf186e72d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad34591e015a68d3dd5f3298d7bea93f89229d83f3f8d4b21e4014237b54d5d1"
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
