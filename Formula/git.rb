class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  # NOTE: Please keep these values in sync with git-gui.rb when updating.
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.32.0.tar.xz"
  sha256 "68a841da3c4389847ecd3301c25eb7e4a51d07edf5f0168615ad6179e3a83623"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/git/git.git"

  livecheck do
    url "https://www.kernel.org/pub/software/scm/git/"
    regex(/href=.*?git[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "74d2f8e5376eb204c5f812bbefc77c81d500fca1295e6571f7c680a36f98a73b"
    sha256 big_sur:       "c73ff9436e9642d745a612ed1071ae770d57fdca95589539d63e1e0c9f428f3b"
    sha256 catalina:      "0f303c5f3bb53ff24d0ba10d7c2612b0f4bc8e384eb082b51a8aff62e4aace72"
    sha256 mojave:        "4610c1e22e2df2e7f0c70146f630675a041064ac904702cbd492b7845be4f88e"
    sha256 x86_64_linux:  "7c2cd04e51354d63daeccae11ec4c4a7f2b532044d462ba89c16f2577851a937"
  end

  depends_on "gettext"
  depends_on "pcre2"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@4.4"
  end

  resource "html" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-htmldocs-2.32.0.tar.xz"
    sha256 "821bd3b5dfd31040bf9ed38ef02df3dcf063546127f07d59ec9669274e8b8818"
  end

  resource "man" do
    url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-2.32.0.tar.xz"
    sha256 "19e3cb0425c94d4ad82984f41522e77c8e35093e15a891f8e7195617201f6ac1"
  end

  # git-send-email needs Net::SMTP::SSL or Net::SMTP >= 2.34
  def self.use_net_smtp_ssl?
    Utils.safe_popen_read("perl", "-MNet::SMTP", "-e",
                          "print version->parse($Net::SMTP::VERSION) >= version->parse('2.34')").empty?
  end

  if use_net_smtp_ssl?
    resource "Net::SMTP::SSL" do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/Net-SMTP-SSL-1.04.tar.gz"
      sha256 "7b29c45add19d3d5084b751f7ba89a8e40479a446ce21cfd9cc741e558332a00"
    end
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["PYTHON_PATH"] = which("python")
    ENV["PERL_PATH"] = which("perl")
    ENV["USE_LIBPCRE2"] = "1"
    ENV["INSTALL_SYMLINKS"] = "1"
    ENV["LIBPCREDIR"] = Formula["pcre2"].opt_prefix
    ENV["V"] = "1" # build verbosely

    perl_version = Utils.safe_popen_read("perl", "--version")[/v(\d+\.\d+)(?:\.\d+)?/, 1]

    on_macos do
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    # Ensure we are using the correct system headers (for curl) to workaround
    # mismatched Xcode/CLT versions:
    # https://github.com/Homebrew/homebrew-core/issues/46466
    if MacOS.version == :mojave && MacOS::CLT.installed? && MacOS::CLT.provides_sdk?
      ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
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

    on_macos do
      args += %w[NO_OPENSSL=1 APPLE_COMMON_CRYPTO=1]
    end
    on_linux do
      openssl_prefix = Formula["openssl@1.1"].opt_prefix
      args += %W[NO_APPLE_COMMON_CRYPTO=1 OPENSSLDIR=#{openssl_prefix}]
    end

    system "make", "install", *args

    git_core = libexec/"git-core"

    # Install the macOS keychain credential helper
    on_macos do
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

    elisp.install Dir["contrib/emacs/*.el"]
    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    if Git.use_net_smtp_ssl?
      resource("Net::SMTP::SSL").stage do
        (share/"perl5").install "lib/Net"
      end
    end

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    on_macos do
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

    # Check Net::SMTP or Net::SMTP::SSL works for git-send-email
    on_macos do
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
end
