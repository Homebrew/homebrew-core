class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.2.tar.xz"
  sha256 "1c3d9c821c4538e7a6dac30a4af8bd8dcfe4f651f95474c526b52f83406db003"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d78f773df4cd7ef1ec23001fd390cfed8048917109655b9bc5706201855053c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9574c9dbb53d0f2db3fd76dfe03783672ed251e603802f81b5e6df17082a8a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "d78f773df4cd7ef1ec23001fd390cfed8048917109655b9bc5706201855053c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9574c9dbb53d0f2db3fd76dfe03783672ed251e603802f81b5e6df17082a8a1c"
    sha256 cellar: :any_skip_relocation, catalina:       "3622485d3da479b77cf8680ff03735e667ce854bd3acc23ab608a0948604ba1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dcd1af9dd8ad61e1c81a6d33fa9e3ee2ef666b57733b9e5bba7b3698c2a0c95"
  end

  depends_on "git"
  depends_on "subversion"

  uses_from_macos "perl"

  def install
    perl = DevelopmentTools.locate("perl")
    perl_version, perl_short_version = Utils.safe_popen_read(perl, "-e", "print $^V")
                                            .match(/v((\d+\.\d+)(?:\.\d+)?)/).captures

    ENV["PERL_PATH"] = perl
    ENV["PERLLIB_EXTRA"] = Formula["subversion"].opt_lib/"perl5/site_perl"/perl_version/"darwin-thread-multi-2level"
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
