class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.51.0.tar.xz"
  sha256 "60a7c2251cc2e588d5cd87bae567260617c6de0c22dca9cdbfc4c7d2b8990b62"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/"
    regex(/href=.*?git[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e4951ba5c6986367f36dc29ea0469cbe1d14e81fd1e79bcd125cf4ccd15f283f"
    sha256 arm64_sequoia: "e757c188846b025c11296d108dbf94cc13ffbdc299f042dcc0d1012236f84182"
    sha256 arm64_sonoma:  "037a3ee5f90aa6e67eb29749f9d37bb4245617ea4ce5a3aca961795b9f8b78b2"
    sha256 arm64_ventura: "ab01726cef10625602ddbcc0bd638ab939a142a5319999fb6f2fc0c995013535"
    sha256 sonoma:        "ca0c4ef521a99c847e6354d042d80f7646409585f84abdb820e83d071d2182f9"
    sha256 ventura:       "b513dbb65664a857c22e963cc233e80e5af97b52b97266d64ec527207f6a6c52"
    sha256 arm64_linux:   "3b87a4e7f1f5cedd7a25af90907ffcbe77d908e3fa523f0da626cbb4d0d950e1"
    sha256 x86_64_linux:  "e3896ae27c969a54d1a400be638d3d5647c96fe18907f02faaf80bbe7965b580"
  end

  depends_on "gettext"
  depends_on "pcre2"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  resource "html" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-htmldocs-2.51.0.tar.xz"
    sha256 "dd33897c676ea140d57a652758e458756fa93582801cfd1d7e1f62acd5fa7580"

    livecheck do
      formula :parent
    end
  end

  resource "man" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-2.51.0.tar.xz"
    sha256 "c10aea63316865ace762078a6e67fc3cf117b11a5c9d4a2a52cb3762ae22ed35"

    livecheck do
      formula :parent
    end
  end

  resource "Net::SMTP::SSL" do
    url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.04.tar.gz"
    sha256 "7b29c45add19d3d5084b751f7ba89a8e40479a446ce21cfd9cc741e558332a00"
  end

  def install
    odie "html resource needs to be updated" if build.stable? && version != resource("html").version
    odie "man resource needs to be updated" if build.stable? && version != resource("man").version

    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["PYTHON_PATH"] = which("python3")
    ENV["PERL_PATH"] = which("perl")
    ENV["USE_LIBPCRE2"] = "1"
    ENV["INSTALL_SYMLINKS"] = "1"
    ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    ENV["V"] = "1" # build verbosely

    perl_version = Utils.safe_popen_read("perl", "--version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]

    if OS.mac?
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    # The git-gui and gitk tools are installed by a separate formula (git-gui)
    # to avoid a dependency on tcl-tk and to avoid using the broken system
    # tcl-tk (see https://github.com/Homebrew/homebrew-core/issues/36390)
    # This is done by setting the NO_TCLTK make variable.
    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      NO_TCLTK=1
    ]

    args += if OS.mac?
      %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    else
      openssl_prefix = Formula["openssl@3"].opt_prefix

      %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    end

    # Make sure `git` looks in `opt_prefix` instead of the Cellar.
    # Otherwise, Cellar references propagate to generated plists from `git maintenance`.
    inreplace "Makefile", /(-DFALLBACK_RUNTIME_PREFIX=")[^"]+/, "\\1#{opt_prefix}"

    system "make", "install", *args

    git_core = libexec/"git-core"
    rm git_core/"git-svn"

    # Install the macOS keychain credential helper
    if OS.mac?
      cd "contrib/credential/osxkeychain" do
        system "make", "CC=#{ENV.cc}",
                       "CFLAGS=#{ENV.cflags}",
                       "LDFLAGS=#{ENV.ldflags}"
        git_core.install "git-credential-osxkeychain"
        system "make", "clean"
      end
    end

    # Generate diff-highlight perl script executable
    cd "contrib/diff-highlight" do
      system "make"
    end

    # Install the netrc credential helper
    cd "contrib/credential/netrc" do
      system "make", "test"
      git_core.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      git_core.install "git-subtree"
    end

    # install the completion script first because it is inside "contrib"
    bash_completion.install "contrib/completion/git-completion.bash"
    bash_completion.install "contrib/completion/git-prompt.sh"
    zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
    cp "#{bash_completion}/git-completion.bash", zsh_completion

    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # git-send-email needs Net::SMTP::SSL or Net::SMTP >= 2.34
    resource("Net::SMTP::SSL").stage do
      (share/"perl5").install "lib/Net"
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    perl_dir = prefix/"Library/Perl"
    rm_r perl_dir if perl_dir.exist?

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    if OS.mac?
      (buildpath/"gitconfig").write <<~EOS
        [credential]
        \thelper = osxkeychain
      EOS
      etc.install "gitconfig"
    end
  end

  def caveats
    <<~EOS
      The Tcl/Tk GUIs (e.g. gitk, git-gui) are now in the `git-gui` formula.
      Subversion interoperability (git-svn) is now in the `git-svn` formula.
    EOS
  end

  test do
    system bin/"git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"git", "add", "haunted", "house"
    system bin/"git", "config", "user.name", "'A U Thor'"
    system bin/"git", "config", "user.email", "author@example.com"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/git ls-files").strip

    # Check that our `inreplace` for the `Makefile` does not break.
    # If this assertion fails, please fix the `inreplace` instead of removing this test.
    # The failure of this test means that `git` will generate broken launchctl plist files.
    refute_match HOMEBREW_CELLAR.to_s, shell_output("#{bin}/git --exec-path")

    return unless OS.mac?

    # Check Net::SMTP or Net::SMTP::SSL works for git-send-email
    %w[foo bar].each { |f| touch testpath/f }
    system bin/"git", "add", "foo", "bar"
    system bin/"git", "commit", "-a", "-m", "Second Commit"
    assert_match "Authentication Required", pipe_output(
      "#{bin}/git send-email --from=test@example.com --to=dev@null.com " \
      "--smtp-server=smtp.gmail.com --smtp-server-port=587 " \
      "--smtp-encryption=tls --confirm=never HEAD^ 2>&1",
    )
  end
end
