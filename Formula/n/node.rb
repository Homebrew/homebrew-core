class Node < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v26.5.0/node-v26.5.0.tar.xz"
  sha256 "0e179470097e247a0c0769b77cc1359fc3e1baf0686df89bafe1fb48cb1887f4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nodejs/node.git", branch: "main"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "05357c510f3dd0330b4cdea26e7ae406cfb55d88834ef83ecd5e3b7418b6ff37"
    sha256 arm64_sequoia: "1bfa4fb49336b52433ae3afab270991b5fd25b7132b82a164d1d1b91e0272316"
    sha256 arm64_sonoma:  "c53c29ad81110180fb9f04d4e6e8dce1a240984fcc917e6895fd0d64a2f4c066"
    sha256 sonoma:        "af22f043c5d834672095dc8871c88b71c1938c35c451f1fe69af1b068f32fc70"
    sha256 arm64_linux:   "e6b70f0acccfb0aafc878d05948480feea9945a66c70572ac68069baafd7ff0a"
    sha256 x86_64_linux:  "d8db2eb60f7f3fcaedc98377f779b1a0826362bf493f362ee1de1880b2c776df"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "ada-url"
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "hdrhistogram_c"
  depends_on "icu4c@78"
  depends_on "libffi" # System `libffi` is missing some definitions used by node
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libngtcp2"
  depends_on "libuv"
  depends_on "llhttp"
  depends_on "merve"
  depends_on "nbytes"
  depends_on "openssl@3"
  depends_on "simdjson"
  depends_on "sqlite" # Fails with macOS sqlite.
  depends_on "uvwasi"
  depends_on "zstd"

  uses_from_macos "python"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
    version "12"
    cause "needs GCC 13 or newer"
  end

  # We track major/minor from upstream Node releases.
  # We will accept *important* npm patch releases when necessary.
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-11.17.0.tgz"
    sha256 "b290bbb35b9e72c3ef84edbe041f28c4479c4d9ee79f555817b8caafe7ce4bba"

    livecheck do
      url "https://raw.githubusercontent.com/nodejs/node/refs/tags/v#{LATEST_VERSION}/deps/npm/package.json"
      strategy :json do |json|
        json["version"]
      end
    end
  end

  deny_network_access! [:build, :postinstall]

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.14")

    # Ensure Homebrew deps are used
    rm_r(["deps/icu-small", "deps/npm"])

    # Never install the bundled "npm", always prefer our
    # installation from tarball for better packaging control.
    # Disable SEA as incompatible with --shared, https://github.com/nodejs/node/issues/63126
    args = %W[
      --prefix=#{prefix}
      --without-npm
      --with-intl=system-icu
      --shared
      --openssl-use-def-ca-store
      --disable-single-executable-application
    ]
    args << "--tag=head" if build.head?

    # Devendor libraries available as formulae. The following maps the name
    # used in configure (e.g. `--shared-<flag>`) to the bundled subdirectory
    # and corresponding formula name as these can all differ.
    {
      # flag name         sub-directory      formula name
      "ada"           => ["ada",             "ada-url"],
      "brotli"        => ["brotli",          "brotli"],
      "cares"         => ["cares",           "c-ares"],
      "ffi"           => ["libffi",          "libffi"],
      "hdr-histogram" => ["histogram",       "hdrhistogram_c"],
      "http-parser"   => ["llhttp",          "llhttp"],
      "libuv"         => ["uv",              "libuv"],
      "merve"         => ["merve",           "merve"],
      "nbytes"        => ["nbytes",          "nbytes"],
      "nghttp2"       => ["nghttp2",         "libnghttp2"],
      "nghttp3"       => ["ngtcp2/nghttp3",  "libnghttp3"],
      "ngtcp2"        => ["ngtcp2",          "libngtcp2"],
      "openssl"       => ["openssl/openssl", "openssl@3"],
      "simdjson"      => ["simdjson",        "simdjson"],
      "sqlite"        => ["sqlite",          "sqlite"],
      "uvwasi"        => ["uvwasi",          "uvwasi"],
      "zlib"          => ["zlib",            ("zlib-ng-compat" unless OS.mac?)],
      "zstd"          => ["zstd",            "zstd"],
    }.each do |flag, (subdir, formula)|
      rm_r(buildpath/"deps"/subdir)
      args << "--shared-#{flag}"
      if formula
        args << "--shared-#{flag}-includes=#{Formula[formula].include}"
        args << "--shared-#{flag}-libpath=#{Formula[formula].lib}"
      end
    end

    # TODO: Try to devendor these libraries.
    # - `--shared-gtest` is only used for building the test suite, which we don't run here.
    # - `--shared-simdutf` seems to result in build failures.
    # - `--shared-temporal_capi` is only used when building with `--v8-enable-temporal-support`
    # - `--shared-lief` is only used for disabled SEA feature
    ignored_shared_flags = %w[
      gtest
      simdutf
      temporal_capi
      lief
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

    # Use the _npm completion included in Zsh rather than generating broken completion
    generate_completions_from_executable(bin/"npm", "completion", shells: [:bash], shell_parameter_format: :none)
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

  # Explain why some features enabled in upstream binaries are disabled in Homebrew.
  # These require fixes upstream for Homebrew to consider enabling them. Do not open issues.
  def caveats
    <<~EOS
      Single Executable Application is disabled as it doesn't work with shared libnode.
      Temporal support is disabled as it doesn't work with shared ICU library.
    EOS
  end

  test do
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

    # Test `uvwasi` is linked correctly
    (testpath/"wasi-smoke-test.mjs").write <<~JAVASCRIPT
      import { WASI } from 'node:wasi';

      // Minimal WASM that:
      //   - imports wasi proc_exit(i32)->()
      //   - exports memory (required by Node's WASI binding)
      //   - exports _start which calls proc_exit(42)
      const wasmBytes = new Uint8Array([
        // \0asm + version
        0x00,0x61,0x73,0x6d, 0x01,0x00,0x00,0x00,

        // Type section: 2 types: (i32)->() and ()->()
        0x01,0x08, 0x02,
          0x60,0x01,0x7f,0x00,
          0x60,0x00,0x00,

        // Import section: wasi_snapshot_preview1.proc_exit : func(type 0)
        0x02,0x24, 0x01,
          0x16, // module name len = 22
            0x77,0x61,0x73,0x69,0x5f,0x73,0x6e,0x61,0x70,0x73,0x68,0x6f,0x74,0x5f,0x70,0x72,0x65,0x76,0x69,0x65,0x77,0x31,
          0x09, // name len = 9
            0x70,0x72,0x6f,0x63,0x5f,0x65,0x78,0x69,0x74,
          0x00, // import kind = func
          0x00, // type index 0

        // Function section: 1 function (type index 1 = ()->())
        0x03,0x02, 0x01, 0x01,

        // Memory section: one memory with min=1 page; export later
        0x05,0x03, 0x01, 0x00, 0x01,

        // Export section: export "_start" (func 1) and "memory" (mem 0)
        0x07,0x13, 0x02,
          0x06, 0x5f,0x73,0x74,0x61,0x72,0x74, 0x00, 0x01,
          0x06, 0x6d,0x65,0x6d,0x6f,0x72,0x79, 0x02, 0x00,

        // Code section: body for func 1: i32.const 42; call 0; end
        0x0a,0x08, 0x01,
          0x06, 0x00, 0x41,0x2a, 0x10,0x00, 0x0b
      ]);

      const wasi = new WASI({
        version: 'preview1',
        returnOnExit: true
      });

      const { instance } = await WebAssembly.instantiate(wasmBytes, wasi.getImportObject());

      // This should return 42 if uvwasi is correctly linked & wired.
      const rc = wasi.start(instance);
      if (rc === 42) {
        console.log('PASS: uvwasi proc_exit(42) worked (exitCode=42)');
        process.exit(0);
      } else {
        console.error('FAIL: unexpected return', rc);
        process.exit(2);
      }
    JAVASCRIPT

    system bin/"node", "wasi-smoke-test.mjs"
  end
end
