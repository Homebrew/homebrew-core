class NodeAT22 < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v22.21.1/node-v22.21.1.tar.xz"
  sha256 "487d73fd4db00dc2420d659a8221b181a7937fbc5bc73f31c30b1680ad6ded6a"
  license "MIT"
  revision 4

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(22(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ebb6b895ce8252b5c63fe3105825eb2531eeda148d8642f4bbd2691f9af1c32b"
    sha256 arm64_sequoia: "689be9ce6e5c302167df06ed91570ea203412db476d4b88d4add341f530ccd98"
    sha256 arm64_sonoma:  "f2f649dacc39440167f36f809dfd5ae8d1621130a778a039094195115eda1b83"
    sha256 sonoma:        "270d589d7dea2b95e8ae229e211d4496fe8536f223ac4a732fddfa8cbc82926d"
    sha256 arm64_linux:   "ddd9022c83400f6d85d71d67d27a76f6536782bb3f996f1d03f812777e9e19cd"
    sha256 x86_64_linux:  "efb446cf122e2d5242b3f50af48bc59ee4b94de0a61c9b202d396ee46e5945d3"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2027-04-30", because: :unsupported
  deprecate! date: "2026-10-28", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@78"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libngtcp2"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "simdjson"
  depends_on "simdutf"
  depends_on "sqlite"
  depends_on "uvwasi"
  depends_on "zstd"

  uses_from_macos "python"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: calling a private constructor of class 'v8::internal::(anonymous namespace)::RegExpParserImpl<uint8_t>'
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared-brotli
      --shared-cares
      --shared-libuv
      --shared-nghttp2
      --shared-nghttp3
      --shared-ngtcp2
      --shared-openssl
      --shared-simdjson
      --shared-simdutf
      --shared-sqlite
      --shared-uvwasi
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
      --shared-simdutf-includes=#{Formula["simdutf"].include}
      --shared-simdutf-libpath=#{Formula["simdutf"].lib}
      --shared-sqlite-includes=#{Formula["sqlite"].include}
      --shared-sqlite-libpath=#{Formula["sqlite"].lib}
      --shared-uvwasi-includes=#{Formula["uvwasi"].include}/uvwasi
      --shared-uvwasi-libpath=#{Formula["uvwasi"].lib}
      --shared-zstd-includes=#{Formula["zstd"].include}
      --shared-zstd-libpath=#{Formula["zstd"].lib}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && build.bottle?

    # TODO: Try to devendor these libraries.
    # - `--shared-ada` needs the `ada-url` formula, but requires C++20
    # - `--shared-http-parser` and `--shared-uvwasi` are not available as dependencies in Homebrew.
    ignored_shared_flags = %w[
      ada
      http-parser
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
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
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
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "nan"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
