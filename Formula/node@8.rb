class NodeAT8 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.9.4/node-v8.9.4.tar.xz"
  sha256 "6cdcde9c9c1ca9f450a0b24eafa229ca759e576daa0fae892ce74d541ecdc86f"
  head "https://github.com/nodejs/node.git", :branch => "v8.x-staging"

  bottle do
    sha256 "e5251ea5fe85aeb8cd4148a2b8a77643a9662e2ffe1e4bd409d6563cb017b853" => :high_sierra
    sha256 "2ccfddbf0dd95e80a50791dcf030731dab1de44053496746129e087f649a0c21" => :sierra
    sha256 "f1944281c5e0fd4efe717198d14749ed0e5210a837d0d8fa94136cdda82aea57" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  # Keep in sync with main node formula
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-5.6.0.tgz"
    sha256 "b1f0de3767136c1d7b4b0f10e6eb2fb3397e2fe11e4c9cddcd0030ad1af9eddd"
  end

  def install
    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" if build.with? "openssl"
    args << "--tag=head" if build.head?

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      # Allow npm to find Node before installation has completed.
      ENV.prepend_path "PATH", bin

      bootstrap = buildpath/"npm_bootstrap"
      bootstrap.install resource("npm")
      system "node", bootstrap/"bin/npm-cli.js", "install", "-ddd", "--global",
             "--prefix=#{libexec}", resource("npm").cached_download

      # The `package.json` stores integrity information about the above passed
      # in `cached_download` npm resource, which breaks `npm -g outdated npm`.
      # This copies back over the vanilla `package.json` to fix this issue.
      cp bootstrap/"package.json", libexec/"lib/node_modules/npm"
      # These symlinks are never used & they've caused issues in the past.
      rm_rf libexec/"share"

      if build.with? "completion"
        bash_completion.install \
          bootstrap/"lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # we make our own. This is a small consequence of our
    # bottle-npm-and-retain-a-private-copy-in-libexec setup
    # All other installs **do** symlink to homebrew_prefix/bin correctly.
    # We ln rather than cp this because doing so mimics npm's normal install.
    ln_sf node_modules/"npm/bin/npm-cli.js", HOMEBREW_PREFIX/"bin/npm"
    ln_sf node_modules/"npm/bin/npx-cli.js", HOMEBREW_PREFIX/"bin/npx"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    %w[man1 man5 man7].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/legacy-homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.,npx.}*"]
      cp Dir[libexec/"lib/node_modules/npm/man/#{man}/{npm,package.json,npx}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    if build.without? "npm"
      <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "icu4c"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :exist?, "npm must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "npm@latest"
      system "#{HOMEBREW_PREFIX}/bin/npm", *npm_args, "install", "bignum" unless head?
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :exist?, "npx must exist"
      assert_predicate HOMEBREW_PREFIX/"bin/npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{HOMEBREW_PREFIX}/bin/npx cowsay hello")
    end
  end
end
