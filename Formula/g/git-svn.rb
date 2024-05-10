class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.45.0.tar.xz"
  sha256 "0aac200bd06476e7df1ff026eb123c6827bc10fe69d2823b4bf2ebebe5953429"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0e3ded63247aa1fac8784a4da12522b596e7de579c9e53746e675e3d0b1d41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5193692c53d6aa68eb64cf9473e15774732063f85d56cbc8e4313f13e559760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5193692c53d6aa68eb64cf9473e15774732063f85d56cbc8e4313f13e559760"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e3ded63247aa1fac8784a4da12522b596e7de579c9e53746e675e3d0b1d41e"
    sha256 cellar: :any_skip_relocation, ventura:        "f5193692c53d6aa68eb64cf9473e15774732063f85d56cbc8e4313f13e559760"
    sha256 cellar: :any_skip_relocation, monterey:       "f5193692c53d6aa68eb64cf9473e15774732063f85d56cbc8e4313f13e559760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574ca6292b51807fb4eb42a819a6790a108f3f5a6839a6301c020e703af53c37"
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
