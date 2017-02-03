class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.11.1.tar.xz"
  sha256 "c0a779cae325d48a1d5ba08b6ee1febcc31d0657a6da01fd1dec1c6e10976415"
  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "3e57569cb8058b98a9c46fe7cf0e65b2b4007286dd607256446abd5cac0e9d8a" => :sierra
    sha256 "505487e55a7a38e08c06f8ac301fa33d4c890c10432ffb3bde5a173dd2fa12b8" => :el_capitan
    sha256 "dc138bfcb944111b4c94f95bd985b8f406ba8fb33e2a449cf641ca5463fee04d" => :yosemite
  end

  option "with-blk-sha1", "Compile with the block-optimized SHA1 implementation"
  option "without-completions", "Disable bash/zsh completions from 'contrib' directory"
  option "with-brewed-openssl", "Build with Homebrew OpenSSL instead of the system version"
  option "with-brewed-curl", "Use Homebrew's version of cURL library"
  option "with-brewed-svn", "Use Homebrew's version of SVN"
  option "with-persistent-https", "Build git-remote-persistent-https from 'contrib' directory"

  depends_on "pcre" => :optional
  depends_on "gettext" => :optional
  depends_on "openssl" if build.with? "brewed-openssl"
  depends_on "curl" if build.with? "brewed-curl"
  depends_on "go" => :build if build.with? "persistent-https"
  # Trigger an install of swig before subversion, as the "swig" doesn't get pulled in otherwise
  # See https://github.com/Homebrew/homebrew/issues/34554
  if build.with? "brewed-svn"
    depends_on "swig"
    depends_on "subversion" => "with-perl"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.11.1.tar.xz"
    sha256 "1a5f1e4a5eadad89b0783efa08bb1f7e3802d4a4d0a135bf5f61fd672ea3846e"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.11.1.tar.xz"
    sha256 "69486ed339ee0591001ae83d43c888aa26351b9680b6ceb59e06b593051bca31"
  end

  def install
    # If these things are installed, tell Git build system not to use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["V"] = "1" # build verbosely
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which "python"
    ENV["PERL_PATH"] = which "perl"

    # Support Tcl versions before "lime" color name was introduced
    # https://github.com/Homebrew/homebrew-core/issues/115
    # https://www.mail-archive.com/git%40vger.kernel.org/msg92017.html
    #
    # This has been resolved in Git (6e8fda5fd), which is currently present
    # in HEAD but not in the stable.  This should be removed later.
    inreplace "gitk-git/gitk", "lime", '"#99FF00"' if build.stable?

    perl_version = /\d\.\d+/.match(`perl --version`)

    if build.with? "brewed-svn"
      ENV["PERLLIB_EXTRA"] = %W[
        #{Formula["subversion"].opt_lib}/perl5/site_perl
        #{Formula["subversion"].opt_prefix}/Library/Perl/#{perl_version}/darwin-thread-multi-2level
      ].join(":")
    elsif MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    ENV["BLK_SHA1"] = "1" if build.with? "blk-sha1"

    if build.with? "pcre"
      ENV["USE_LIBPCRE"] = "1"
      ENV["LIBPCREDIR"] = Formula["pcre"].opt_prefix
    end

    ENV["NO_GETTEXT"] = "1" if build.without? "gettext"

    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
    ]
    args << "NO_OPENSSL=1" << "APPLE_COMMON_CRYPTO=1" if build.without? "brewed-openssl"

    system "make", "install", *args

    # Install the macOS keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-credential-osxkeychain"
      system "make", "clean"
    end

    # Install the netrc credential helper
    cd "contrib/credential/netrc" do
      system "make", "test"
      bin.install "git-credential-netrc"
    end

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-subtree"
    end

    if build.with? "persistent-https"
      cd "contrib/persistent-https" do
        system "make"
        bin.install "git-remote-persistent-http",
                    "git-remote-persistent-https",
                    "git-remote-persistent-https--proxy"
      end
    end

    if build.with? "completions"
      # install the completion script first because it is inside "contrib"
      bash_completion.install "contrib/completion/git-completion.bash"
      bash_completion.install "contrib/completion/git-prompt.sh"

      zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    elisp.install Dir["contrib/emacs/*.el"]
    (share/"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share/"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-brewed-openssl.
    rm "#{libexec}/git-core/git-imap-send" if build.without? "brewed-openssl"

    # Set the macOS keychain credential helper by default
    # (as Apple's CLT's git also does this).
    (buildpath/"gitconfig").write <<-EOS.undent
      [credential]
      \thelper = osxkeychain
    EOS
    etc.install "gitconfig"
  end

  test do
    system bin/"git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"git", "add", "haunted", "house"
    system bin/"git", "commit", "-a", "-m", "Initial Commit"
    assert_equal "haunted\nhouse", shell_output("#{bin}/git ls-files").strip
  end
end
