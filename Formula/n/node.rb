class Node < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v24.4.1/node-v24.4.1.tar.xz"
  sha256 "adb79ca0987486ed66136213da19ff17ef6724dcb340c320e010c9442101652f"
  license "MIT"
  head "https://github.com/nodejs/node.git", branch: "main"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "e3b31f9b31a2b7afa8c9e8f1c8fa4b0136cf9e60b0a4385015486706f8a9286b"
    sha256 arm64_sonoma:  "9455851df579660bd8f6791105412cfdc4118bbb660fe3513cf6d018ee954e16"
    sha256 arm64_ventura: "ff09188d924e5419232644b943c2fd9e74748ad2ee39702d64bc356fc7cc97a3"
    sha256 sonoma:        "d315020d1a5dae78188e19c0c17261c14549e4b61b851fddc34d9a615a0346dc"
    sha256 ventura:       "0aa07c3b2db7ae979215a0b6ed552bcabf666971240f3d599d9df0755bc38060"
    sha256 arm64_linux:   "f563cfc7b948a7b6f49f73a469a475bc244e221c01d01e8518d950b2fdd54952"
    sha256 x86_64_linux:  "066d8195bd40a2cd20f9f1a45b8777e6be0cbdf09a282fd360c53170ddcb2b3c"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@77"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libngtcp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "simdjson"
  depends_on "sqlite" # Fails with macOS sqlite.
  depends_on "zstd"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    # Avoid newer GCC which creates binary with higher GLIBCXX requiring runtime dependency
    depends_on "gcc@12" => :build if DevelopmentTools.gcc_version("/usr/bin/gcc") < 12
  end

  link_overwrite "bin/npm", "bin/npx"

  # https://github.com/swiftlang/llvm-project/commit/078651b6de4b767b91e3e6a51e5df11a06d7bc4f
  fails_with :clang do
    build 1699
    cause "needs SFINAE-friendly std::pointer_traits"
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
    url "https://registry.npmjs.org/npm/-/npm-11.4.2.tgz"
    sha256 "8b469a56d85a61abd846e78690623ce956b4d49ae56f15ac76dea0dce3bd4b2b"
  end

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1699
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # Work around failure mixing newer `llvm` headers with older Xcode's libc++:
      # Undefined symbols for architecture x86_64:
      #   "std::__1::__libcpp_verbose_abort(char const*, ...)", referenced from:
      #       std::__1::__throw_length_error[abi:nn200100](char const*) in js2c.o
      #       std::__throw_bad_array_new_length[abi:nn200100]() in js2c.o
      #       std::__1::__throw_out_of_range[abi:nn200100](char const*) in js2c.o
      #       std::__1::__throw_bad_function_call[abi:nn200100]() in js2c.o
      #       std::__1::__throw_length_error[abi:nn200100](char const*) in embedded_data.o
      #       std::__1::__throw_length_error[abi:nn200100](char const*) in libsimdutf.a(simdutf.o)
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", "#{Formula["llvm"].opt_lib}/c++"
    end

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
      --shared-brotli
      --shared-cares
      --shared-libuv
      --shared-nghttp2
      --shared-nghttp3
      --shared-ngtcp2
      --shared-openssl
      --shared-simdjson
      --shared-sqlite
      --shared-zlib
      --shared-zstd
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --shared-libuv-includes=#{Formula["libuv"].include}
      --shared-libuv-libpath=#{Formula["libuv"].lib}
      --shared-nghttp2-includes=#{Formula["libnghttp2"].include}
      --shared-nghttp2-libpath=#{Formula["libnghttp2"].lib}
      --shared-nghttp3-includes=#{Formula["libnghttp3"].include}
      --shared-nghttp3-libpath=#{Formula["libnghttp3"].lib}
      --shared-ngtcp2-includes=#{Formula["libngtcp2"].include}
      --shared-ngtcp2-libpath=#{Formula["libngtcp2"].lib}
      --shared-openssl-includes=#{Formula["openssl@3"].include}
      --shared-openssl-libpath=#{Formula["openssl@3"].lib}
      --shared-simdjson-includes=#{Formula["simdjson"].include}
      --shared-simdjson-libpath=#{Formula["simdjson"].lib}
      --shared-sqlite-includes=#{Formula["sqlite"].include}
      --shared-sqlite-libpath=#{Formula["sqlite"].lib}
      --shared-zstd-includes=#{Formula["zstd"].include}
      --shared-zstd-libpath=#{Formula["zstd"].lib}
      --openssl-use-def-ca-store
    ]
    args << "--tag=head" if build.head?

    # TODO: Try to devendor these libraries.
    # - `--shared-ada` needs the `ada-url` formula, but requires C++20
    # - `--shared-simdutf` seems to result in build failures.
    # - `--shared-http-parser` and `--shared-uvwasi` are not available as dependencies in Homebrew.
    ignored_shared_flags = %w[
      ada
      http-parser
      simdutf
      uvwasi
    ].map { |library| "--shared-#{library}" }

    configure_help = Utils.safe_popen_read("./configure", "--help")
    shared_flag_regex = /\[(--shared-[^ \]]+)\]/
    configure_help.scan(shared_flag_regex) do |matches|
      matches.each do |flag|
        next if args.include?(flag) || ignored_shared_flags.include?(flag)

        message = "Unused `--shared-*` flag: #{flag}"
        if build.head?
          opoo message
        else
          odie message
        end
      end
    end

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # macOS also can't build with LTO when using LLVM Clang
    # LTO is unpleasant if you have to build from source.
    # FIXME: re-enable me, currently crashes sequoia runner after 6 hours
    # args << "--enable-lto" if OS.mac? && DevelopmentTools.clang_build_version > 1699 && build.bottle?

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
