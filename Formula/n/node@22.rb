class NodeAT22 < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v22.23.3/node-v22.23.3.tar.xz"
  sha256 "bd97093e1a1e9243338950c174a693a64d4e0926a9c6ce259962bc58d5e96909"
  license "MIT"
  revision 3
  compatibility_version 1

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(22(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f372190c8b5af0a37babbade1e5730be523961b7513b9a0efdc65633a8223711"
    sha256 cellar: :any, arm64_tahoe:       "728b0d030ea10fc6d2c6606e6851044326f55fe9e3402f3db2832ad8e53d581e"
    sha256 cellar: :any, arm64_sequoia:     "4e37e9e3f45cd613a3617f5ed5029a92a3f5ed7906959bf6e86f1165e98d3e70"
    sha256 cellar: :any, arm64_linux:       "3c2e6e718a6f0c3f53c66f0f50402eed23d5d46df4794895314a883675984e9b"
    sha256 cellar: :any, x86_64_linux:      "c3e567704dcaed016b96e988bd7c83852cb5bd075d6ec573a1a14213c34f85a2"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # Deprecation set 6 months before EOL and disable date set 6 months after EOL
  deprecate! date: "2026-10-30", because: "is in maintenance and will be end-of-life on 2027-04-30"
  disable! date: "2027-10-30", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@78"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "simdjson"
  depends_on "sqlite"
  depends_on "uvwasi"
  depends_on "zstd"

  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python3
    # simdjson 5 `key_selector` uses `throw` in consteval, which clang <= 20 rejects with -fno-exceptions
    ENV.append "CXXFLAGS", "-DSIMDJSON_CONCEPT_DISABLED"

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared
      --shared-brotli
      --shared-cares
      --shared-libuv
      --shared-nghttp2
      --shared-nghttp3
      --shared-openssl
      --shared-simdjson
      --shared-sqlite
      --shared-uvwasi
      --shared-zlib
      --shared-zstd
      --shared-brotli-includes=#{formula_opt_include("brotli")}
      --shared-brotli-libpath=#{formula_opt_lib("brotli")}
      --shared-cares-includes=#{formula_opt_include("c-ares")}
      --shared-cares-libpath=#{formula_opt_lib("c-ares")}
      --shared-libuv-includes=#{formula_opt_include("libuv")}
      --shared-libuv-libpath=#{formula_opt_lib("libuv")}
      --shared-nghttp2-includes=#{formula_opt_include("libnghttp2")}
      --shared-nghttp2-libpath=#{formula_opt_lib("libnghttp2")}
      --shared-nghttp3-includes=#{formula_opt_include("libnghttp3")}
      --shared-nghttp3-libpath=#{formula_opt_lib("libnghttp3")}
      --shared-openssl-includes=#{formula_opt_include("openssl@3")}
      --shared-openssl-libpath=#{formula_opt_lib("openssl@3")}
      --shared-simdjson-includes=#{formula_opt_include("simdjson")}
      --shared-simdjson-libpath=#{formula_opt_lib("simdjson")}
      --shared-sqlite-includes=#{formula_opt_include("sqlite")}
      --shared-sqlite-libpath=#{formula_opt_lib("sqlite")}
      --shared-uvwasi-includes=#{formula_opt_include("uvwasi")}/uvwasi
      --shared-uvwasi-libpath=#{formula_opt_lib("uvwasi")}
      --shared-zstd-includes=#{formula_opt_include("zstd")}
      --shared-zstd-libpath=#{formula_opt_lib("zstd")}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && build.bottle?

    ignored_shared_flags = %w[
      ada
      http-parser
      ngtcp2
      simdutf
    ].map { |library| "--shared-#{library}" }

    configure_help = Utils.safe_popen_read("./configure", "--help")
    shared_flag_regex = /\[(--shared-[^ \]]+)\]/
    configure_help.scan(shared_flag_regex) do |matches|
      matches.each do |flag|
        next if args.include?(flag) || ignored_shared_flags.include?(flag)

        odie "Unused `--shared-*` flag: #{flag}"
      end
    end

    system "./configure", *args
    system "make", "install"

    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
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
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "nan"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")

    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/npm config get prefix").chomp
  end
end
