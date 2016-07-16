class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.9.2.tar.xz"
  sha256 "f8f546648f77f246f1302e3ec4037c81db25af1f02931597148c5bf61fac2db5"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "98aa5ac5634365c768013c3007d88e4dbbfcef607fb5fd8df82024b7e5320fc9" => :el_capitan
    sha256 "5b5460409196083456cf657f6a8ea9661bc3079feb06a106e0d80ef546e00e56" => :yosemite
    sha256 "e0bc597031a6f45a83ade135a64db4ed9283759c93da3ee297f169c0d64553c9" => :mavericks
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
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.9.2.tar.xz"
    sha256 "6dddb003184f2ab68aa6b54e02e1e55c82c774fe6e74602e9dbefdf06826fb1c"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.9.2.tar.xz"
    sha256 "4c5c516ee4c0412b9475739e2125a257f6022e7c7bd006827c376fe70d47c323"
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
    inreplace "gitk-git/gitk", "lime", '"#99FF00"'

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

    # Install the OS X keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-credential-osxkeychain"
      system "make", "clean"
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

    # Set the OS X keychain credential helper by default
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
