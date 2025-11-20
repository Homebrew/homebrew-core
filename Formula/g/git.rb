class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.52.0.tar.xz"
  sha256 "3cd8fee86f69a949cb610fee8cd9264e6873d07fa58411f6060b3d62729ed7c5"
  license "GPL-2.0-only"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/"
    regex(/href=.*?git[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8c43e1c8916f146d294922af82de59ec9ecc897d2ad518c51049104708a61c5a"
    sha256 arm64_sequoia: "237d6093833bb6b4d13e9ce601aed25257da006e091895c2b069b1101ce87444"
    sha256 arm64_sonoma:  "40042fdb9e8223f35f6808e04d3471735357462784ca77e3cb4c5ce97f13c6d8"
    sha256 sonoma:        "3423ab7630438cf26cc38759856cae3a3d80b9328b7f9e72a981d199d427b602"
    sha256 arm64_linux:   "2e58298564bb960362eb4c75f101b7d878d66471a948f83b5767304b0488f865"
    sha256 x86_64_linux:  "0bfd0b1eae2f70cacf14971bdfef206f6aea78a1c4c4c19f486705766f743954"
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
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-htmldocs-2.52.0.tar.xz"
    sha256 "e6efd0da47a15b6a59401c8c5c8944e4315b18a176b89bb57812778d6307be84"

    livecheck do
      formula :parent
    end
  end

  resource "man" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-2.52.0.tar.xz"
    sha256 "23186deddb3083bbaa9eb947cde26a5c7322d7fdb75bb4b3d60795db38221ac5"

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
