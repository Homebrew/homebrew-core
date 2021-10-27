class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.33.1.tar.xz"
  sha256 "e054a6e6c2b088bd1bff5f61ed9ba5aa91c9a3cd509539a4b41c5ddf02201f2f"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b0af7c6eb7c5cfb9825289b540d78cd1870517a28dbd0f7211550295cc0d23b"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b0af7c6eb7c5cfb9825289b540d78cd1870517a28dbd0f7211550295cc0d23b"
    sha256 cellar: :any_skip_relocation, catalina:      "2e59871e0a1767fb6ed63478ce9215d2e125d5d4c28271fee6610417a1a0b96f"
    sha256 cellar: :any_skip_relocation, mojave:        "2e59871e0a1767fb6ed63478ce9215d2e125d5d4c28271fee6610417a1a0b96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f60df3b6a37a84b205d5c25686dcf9cdbca68d3d59bf6e10e9f67713a16b168"
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
