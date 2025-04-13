class Node < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v23.11.0/node-v23.11.0.tar.xz"
  sha256 "f2c5db21fc5d3c3d78c7e8823bff770cef0da8078c3b5ac4fa6d17d5a41be99d"
  license "MIT"
  head "https://github.com/nodejs/node.git", branch: "main"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "5e18e143193267631cacdb1b349af222a4e0354461a844840b8f74e1096ee187"
    sha256 arm64_sonoma:  "9bbd828006bd4a3beacca4c5c4169921c0652f71c5f329a6d41dfac23c36a0bd"
    sha256 arm64_ventura: "9be149abb8ce827d580ea1557c6be8a71222fa38cb785af0cb879694bd0db28d"
    sha256 sonoma:        "31eb61b74270e89351c557b688948fe90a50f9838ca1870fe304c19816e6a7af"
    sha256 ventura:       "815de04f73bb36c3d71799b1f44601a2d7b10b56bc16fee1fac1d8c39c7c2c75"
    sha256 arm64_linux:   "f82e24cf67c6b2d58da09272dda33d760834aabed910267847c09265b2320f71"
    sha256 x86_64_linux:  "2cee5b721e8a6f1dd08dd9117222ddc3353d368153e5ecbeff2cb3e21eb76da7"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@77"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    # Avoid newer GCC which creates binary with higher GLIBCXX requiring runtime dependency
    depends_on "gcc@12" => :build if DevelopmentTools.gcc_version("/usr/bin/gcc") < 12
  end

  # https://github.com/swiftlang/llvm-project/commit/94461822c75d5080bf648f86552f7a59b76905c9
  fails_with :clang do
    build 1500
    cause "needs std::ranges::elements_view"
  end

  # https://github.com/nodejs/node/blob/main/BUILDING.md#supported-toolchains
  # https://github.com/ada-url/ada?tab=readme-ov-file#requirements
  fails_with :gcc do
    version "11"
    cause "needs GCC 12 or newer"
  end

  # We track major/minor from upstream Node releases.
  # We will accept *important* npm patch releases when necessary.
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-10.9.2.tgz"
    sha256 "5cd1e5ab971ea6333f910bc2d50700167c5ef4e66da279b2a3efc874c6b116e4"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    # The new linker crashed during LTO due to high memory usage.
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    args = %W[
      --prefix=#{prefix}
      --without-npm
      --with-intl=system-icu
      --shared-libuv
      --shared-nghttp2
      --shared-openssl
      --shared-zlib
      --shared-brotli
      --shared-cares
      --shared-libuv-includes=#{Formula["libuv"].include}
      --shared-libuv-libpath=#{Formula["libuv"].lib}
      --shared-nghttp2-includes=#{Formula["libnghttp2"].include}
      --shared-nghttp2-libpath=#{Formula["libnghttp2"].lib}
      --shared-openssl-includes=#{Formula["openssl@3"].include}
      --shared-openssl-libpath=#{Formula["openssl@3"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]
    args << "--tag=head" if build.head?

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # macOS also can't build with LTO when using LLVM Clang
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && DevelopmentTools.clang_build_version > 1500 && build.bottle?

    system "./configure", *args
    system "make", "install"

    # Allow npm to find Node before installation has completed.
    ENV.prepend_path "PATH", bin

    bootstrap = buildpath/"npm_bootstrap"
    bootstrap.install resource("npm")
    # These dirs must exists before npm install.
    mkdir_p libexec/"lib"
    system "node", bootstrap/"bin/npm-cli.js", "install", "-ddd", "--global",
            "--prefix=#{libexec}", resource("npm").cached_download

    # The `package.json` stores integrity information about the above passed
    # in `cached_download` npm resource, which breaks `npm -g outdated npm`.
    # This copies back over the vanilla `package.json` to fix this issue.
    cp bootstrap/"package.json", libexec/"lib/node_modules/npm"

    # These symlinks are never used & they've caused issues in the past.
    rm_r libexec/"share" if (libexec/"share").exist?

    # Create temporary npm and npx symlinks until post_install is done.
    ln_s libexec/"lib/node_modules/npm/bin/npm-cli.js", bin/"npm"
    ln_s libexec/"lib/node_modules/npm/bin/npx-cli.js", bin/"npx"

    bash_completion.install bootstrap/"lib/utils/completion.sh" => "npm"
  end

  def post_install
    node_modules = HOMEBREW_PREFIX/"lib/node_modules"
    node_modules.mkpath
    # Remove npm but preserve all other modules across node updates/upgrades.
    rm_r node_modules/"npm" if (node_modules/"npm").exist?

    cp_r libexec/"lib/node_modules/npm", node_modules
    # This symlink doesn't hop into homebrew_prefix/bin automatically so
    # we make our own. This is a small consequence of our
    # bottle-npm-and-retain-a-private-copy-in-libexec setup
    # All other installs **do** symlink to homebrew_prefix/bin correctly.
    # We ln rather than cp this because doing so mimics npm's normal install.
    ln_sf node_modules/"npm/bin/npm-cli.js", bin/"npm"
    ln_sf node_modules/"npm/bin/npx-cli.js", bin/"npx"
    ln_sf bin/"npm", HOMEBREW_PREFIX/"bin/npm"
    ln_sf bin/"npx", HOMEBREW_PREFIX/"bin/npx"

    # Create manpage symlinks (or overwrite the old ones)
    %w[man1 man5 man7].each do |man|
      # Dirs must exist first: https://github.com/Homebrew/legacy-homebrew/issues/35969
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      # still needed to migrate from copied file manpages to symlink manpages
      rm(Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.,package.json.,npx.}*"])
      ln_sf Dir[node_modules/"npm/man/#{man}/{npm,package-,shrinkwrap-,npx}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    (node_modules/"npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    # Make sure Mojave does not have `CC=llvm_clang`.
    ENV.clang if OS.mac?

    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_path_exists HOMEBREW_PREFIX/"bin/npm", "npm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system HOMEBREW_PREFIX/"bin/npm", *npm_args, "install", "npm@latest"
    system HOMEBREW_PREFIX/"bin/npm", *npm_args, "install", "nan"
    assert_path_exists HOMEBREW_PREFIX/"bin/npx", "npx must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{HOMEBREW_PREFIX}/bin/npx --yes cowsay hello")
  end
end
