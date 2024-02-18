class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v20.11.1/node-v20.11.1.tar.xz"
  sha256 "77813edbf3f7f16d2d35d3353443dee4e61d5ee84d9e3138c7538a3c0ca5209e"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "546191e087bf64a41f2a8817872dc1f61ad14005131b838b4a99d014c2001621"
    sha256 arm64_ventura:  "3349950b55288f89dcbac3f8f247ebdf98d0a7663c21e74a22fae3617c9a8355"
    sha256 arm64_monterey: "58d0d3de629859fc5889be1861888a90432dc6e43339f10e4a8d955bf0a876b7"
    sha256 sonoma:         "762b4c6e89a150c83db71c5e7b9485f89d9b8283c17eb6edc6f1f127f718ba69"
    sha256 ventura:        "3d90b7fcd1c12acb4670161fa082ca16671cf849fbd58eefabbc26e5427afc4e"
    sha256 monterey:       "3579874b566c53bdbefe62163fae64082ec3ed965081d7daabbf2aad40b744a1"
    sha256 x86_64_linux:   "cee876f12a41948f7f40c7c9e641d4edd0c7434d319c5182056cac67a2afbe6b"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2026-04-30", because: :unsupported
  deprecate! date: "2025-10-28", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => [:build, :test] if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      error: calling a private constructor of class 'v8::internal::(anonymous namespace)::RegExpParserImpl<uint8_t>'
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # The new linker crashed during LTO due to high memory usage.
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.12")

    args = %W[
      --prefix=#{prefix}
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

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # Pre-Catalina macOS also can't build with LTO
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && MacOS.version >= :catalina && build.bottle?

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
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi" unless head?
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
