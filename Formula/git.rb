class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.8.3.tar.xz"
  sha256 "7d8e6c274a88b4a73b3c98c70d3438ec12871300ce8bb4ca179ea19fcf74aa91"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "195d68fcdb7a4636a283186756248c67558e521b22f525ca93a28cc964aa8d26" => :el_capitan
    sha256 "a4de8e2cdc8e6469ccc34069f0a4e311bd6c9fda3ab6e5697a4cada2971019c6" => :yosemite
    sha256 "73239f5faf3ebd011676a0e45977bafebc355044a3ade5bb45331745edaedbbc" => :mavericks
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
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.8.3.tar.xz"
    sha256 "df9aa1f374ca49dd65f47a8bb1498c11567d963e30cf00e097aa89c495d3ccde"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.8.3.tar.xz"
    sha256 "9d25e10c2bc327fdc59820bb00075799487095059d652fb32fea1cdb3a898bc6"
  end

  def install
    # If these things are installed, tell Git build system to not use them
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
        #{Formula["subversion"].opt_prefix}/lib/perl5/site_perl
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
    (share+"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share+"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-brewed-openssl.
    rm "#{libexec}/git-core/git-imap-send" if build.without? "brewed-openssl"

    # Set the OS X keychain credential helper by default
    # (as Apple's CLT's git also does this).
    (buildpath/"gitconfig").write <<-EOS
      [credential]
        helper = osxkeychain
    EOS
    etc.install "gitconfig"
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", `#{bin}/git ls-files -- bin`.strip
    end
  end
end
