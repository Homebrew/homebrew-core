class Node < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v26.8.1/node-v26.8.1.tar.xz"
  sha256 "d1698832a1a10f050cdda044a3e3d6a748246811e2e7bc89ba9a8bd693dc45f2"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nodejs/node.git", branch: "main"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "489838f28f1131c8555ea7b61fffbb4f957c8a20a4731d2305869084fb864db4"
    sha256 arm64_sequoia: "57b4cb8b3798e1aadec47d67c546ffd3bd90829ffda42953a1fb4ffa492a0efd"
    sha256 arm64_sonoma:  "dd9950f4de42c441edf498dbcab731ab71dc5ab1ae5a4aed19051df404c743e4"
    sha256 arm64_linux:   "f5616d4a4451959b8466459f8dc332dd12278e6b1d6de301515342ac833e9a15"
    sha256 x86_64_linux:  "b675cb3382050af5150399ad247c6760ee92e3647f1d7a0942ddba9bbd6a56c1"
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
    url "https://registry.npmjs.org/npm/-/npm-11.19.0.tgz"
    sha256 "31e9770f7dc71119a58509353b27917557aaf0ac9b5ef1a0465ee7d8ec67ae75"

    livecheck do
      url "https://raw.githubusercontent.com/nodejs/node/refs/tags/v#{LATEST_VERSION}/deps/npm/package.json"
      strategy :json do |json|
        json["version"]
      end
    end
  end

  deny_network_access! [:build, :postinstall]

  def install
    # `ncrypto.cc` uses `std::vector` but libc++ 23 dropped the transitive include
    inreplace "deps/ncrypto/ncrypto.cc",
              "#include <string_view>", "#include <string_view>\n#include <vector>"
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python3

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
        args << "--shared-#{flag}-includes=#{formula_opt_include(formula)}"
        args << "--shared-#{flag}-libpath=#{formula_opt_lib(formula)}"
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

    # Enabling LTO causes brew to error on Linux with a vague message:
    # Error: Process completed with exit code 123.
    # macOS also can't build with LTO when using LLVM Clang
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && ENV.compiler == :clang && build.bottle?

    system "./configure", *args
    system "make", "install"

    # Allow npm to find Node before installation has completed.
    ENV.prepend_path "PATH", bin

    bootstrap = buildpath/"npm_bootstrap"
    bootstrap.install resource("npm")
    # These dirs must exists before npm install.
    (libexec/"lib").mkpath
    system "node", bootstrap/"bin/npm-cli.js", "install", "--loglevel=silly", "--global",
            "--prefix=#{libexec}", resource("npm").cached_download

    # The `package.json` stores integrity information about the above passed
    # in `cached_download` npm resource, which breaks `npm -g outdated npm`.
    # This copies back over the vanilla `package.json` to fix this issue.
    (libexec/"lib/node_modules/npm").install bootstrap/"package.json"

    # These symlinks are never used & they've caused issues in the past.
    rm_r libexec/"share" if (libexec/"share").exist?

    # Create temporary npm and npx symlinks until post_install is done.
    bin.install_symlink libexec/"lib/node_modules/npm/bin/npm-cli.js" => "npm"
    bin.install_symlink libexec/"lib/node_modules/npm/bin/npx-cli.js" => "npx"

    # Use the _npm completion included in Zsh rather than generating broken completion
    generate_completions_from_executable(bin/"npm", "completion", shells: [:bash], shell_parameter_format: :none)

    (libexec/"lib/node_modules/npm/npmrc").write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  # Replace npm but preserve all other modules across node updates/upgrades.
  # The bin symlink is to overwrite the temporary npm and npx symlinks to use
  # global path. Also create manpage symlinks (or overwrite the old ones).
  post_install_steps do
    mkdir_p "{{HOMEBREW_PREFIX}}/lib/node_modules"
    mkdir_p "{{HOMEBREW_PREFIX}}/share/man/man1"
    mkdir_p "{{HOMEBREW_PREFIX}}/share/man/man5"
    mkdir_p "{{HOMEBREW_PREFIX}}/share/man/man7"
    if_path_exists "{{HOMEBREW_PREFIX}}/lib/node_modules/npm" do
      remove "{{HOMEBREW_PREFIX}}/lib/node_modules/npm", recursive: true
    end
    copy "{{libexec}}/lib/node_modules/npm", "{{HOMEBREW_PREFIX}}/lib/node_modules", recursive: true
    symlink "{{HOMEBREW_PREFIX}}/lib/node_modules/npm/bin/npm-cli.js", "{{bin}}/npm", overwrite: true
    symlink "{{HOMEBREW_PREFIX}}/lib/node_modules/npm/bin/npx-cli.js", "{{bin}}/npx", overwrite: true
    symlink "{{HOMEBREW_PREFIX}}/lib/node_modules/npm/man/man1/{npm,npx,package-}*",
            "{{HOMEBREW_PREFIX}}/share/man/man1", overwrite: true, source_glob: true
    symlink "{{HOMEBREW_PREFIX}}/lib/node_modules/npm/man/man5/{npm,npx,package-}*",
            "{{HOMEBREW_PREFIX}}/share/man/man5", overwrite: true, source_glob: true
    symlink "{{HOMEBREW_PREFIX}}/lib/node_modules/npm/man/man7/{npm,npx,package-}*",
            "{{HOMEBREW_PREFIX}}/share/man/man7", overwrite: true, source_glob: true
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
