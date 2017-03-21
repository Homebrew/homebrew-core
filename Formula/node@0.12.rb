class NodeAT012 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v0.12.18/node-v0.12.18.tar.xz"
  sha256 "aec65fae74d1b8d649c145f8ede70afa481002af49cca3336368a7502cb0dc1f"
  revision 2
  head "https://github.com/nodejs/node.git", :branch => "v0.12-staging"

  bottle do
    sha256 "51c70b3652b479638db3f31a5fef8d4aab60f78a1f2ac096d9de49787acae1bc" => :sierra
    sha256 "dd8d6548b9b20f0b6eb56e67c272cb3fbe51f34a8969c5194d9ce64c417ee6d6" => :el_capitan
    sha256 "2e13ca45909852a1e2f1df034f6d774b92251ab05c605e90b4eb41bf6bf22028" => :yosemite
  end

  option "with-debug", "Build with debugger hooks"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  # https://github.com/nodejs/node-v0.x-archive/issues/7919
  # https://github.com/Homebrew/homebrew/issues/36681
  depends_on "icu4c" => :optional

  conflicts_with "node", :because => "Differing version of same formula"
  conflicts_with "node@0.10", :because => "Differing version of same formula"

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.15.11.tgz"
    sha256 "927974142c9a44e9bd879d9e9762e7de379b43c5acfae32b02b44f60e59a9c9c"
  end

  def install
    args = %W[--prefix=#{prefix} --without-npm]
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"

    if build.with? "openssl"
      args << "--shared-openssl"
    else
      args << "--without-ssl3"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "npm"
      resource("npm").stage buildpath/"npm_install"

      # make sure npm can find node
      ENV.prepend_path "PATH", bin
      # set log level temporarily for npm's `make install`
      ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
      # unset prefix temporarily for npm's `make install`
      ENV.delete "NPM_CONFIG_PREFIX"

      cd buildpath/"npm_install" do
        system "./configure", "--prefix=#{libexec}/npm"
        system "make", "install"
        # `package.json` has relative paths to the npm_install directory.
        # This copies back over the vanilla `package.json` that is expected.
        # https://github.com/Homebrew/homebrew/issues/46131#issuecomment-157845008
        cp buildpath/"npm_install/package.json", libexec/"npm/lib/node_modules/npm"
        # Remove manpage symlinks from the buildpath, they are breaking bottle
        # creation. The real manpages are living in libexec/npm/lib/node_modules/npm/man/
        # https://github.com/Homebrew/homebrew/pull/47081#issuecomment-165280470
        rm_rf libexec/"npm/share/"
      end

      if build.with? "completion"
        bash_completion.install \
          buildpath/"npm_install/lib/utils/completion.sh" => "npm"
      end
    end
  end

  def post_install
    return if build.without? "npm"

    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    npm_exec = node_modules/"npm/bin/npm-cli.js"
    # Kill npm but preserve all other modules across node updates/upgrades.
    rm_rf node_modules/"npm"

    cp_r libexec/"npm/lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # remove it and make our own. This is a small consequence of our bottle
    # npm make install workaround. All other installs **do** symlink to
    # homebrew_prefix/bin correctly. We ln rather than cp this because doing
    # so mimics npm's normal install.
    ln_sf npm_exec, "#{HOMEBREW_PREFIX}/bin/npm"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    ["man1", "man3", "man5", "man7"].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.}*"]
      ln_sf Dir[libexec/"npm/lib/node_modules/npm/man/#{man}/{npm,package.json}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = node_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    s = ""

    if build.without? "npm"
      s += <<-EOS.undent
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end

    if build.with? "icu4c"
      s += <<-EOS.undent

        Please note `icu4c` is built with a newer deployment target than Node and
        this may cause issues in certain usage. Node itself is built against the
        outdated `libstdc++` target, which is the root cause. For more information see:
          https://github.com/nodejs/node-v0.x-archive/issues/7919

        If this is an issue for you, do `brew install node --without-icu4c`.
      EOS
    end

    s
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      assert_equal which("node"), opt_bin/"node"
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      system "#{HOMEBREW_PREFIX}/bin/npm", "--verbose", "install", "npm@latest"
    end
  end
end
