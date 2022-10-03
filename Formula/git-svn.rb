class GitSvn < Formula
  desc "Bidirectional operation between a Subversion repository and Git"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.3.tar.xz"
  sha256 "814641d7f61659cfbc17825d0462499ca1403e39ff53d76a8512050e6483e87a"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54faf3c9f04acdbf422dbb81721fd871b387a8535c8716d2886bc09cc907b3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6d0c0edafdf5de860e2dfccd058de644e87020fb06161b2a5736634596c7c7b"
    sha256 cellar: :any_skip_relocation, monterey:       "a54faf3c9f04acdbf422dbb81721fd871b387a8535c8716d2886bc09cc907b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6d0c0edafdf5de860e2dfccd058de644e87020fb06161b2a5736634596c7c7b"
    sha256 cellar: :any_skip_relocation, catalina:       "7266ffbab19efcaa9d40a8f3159bf7032c8c2bc99daa26a9cbf183c2a82a24d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656959c9cb47146837622f05d14027f2cb7eecffae8c32567276984694c29fba"
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
