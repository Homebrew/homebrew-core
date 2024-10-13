class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v20.18.0/node-v20.18.0.tar.xz"
  sha256 "7d9433e91fd88d82ba8de86e711ec41907638e227993d22e95126b02f6cd714a"
  license "MIT"
  revision 1

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "fd0df56bde79e20cbc279997e65e58c4924f868b70098f67a26c569622adaaff"
    sha256 arm64_sonoma:  "fa339fffcdfe46f2e559a8f970e4877fffdba8fda457feaac05efa94503e7f30"
    sha256 arm64_ventura: "74d229c42c021499276264761ec95f278a92a42efb1ed7098771407f50f1d738"
    sha256 sonoma:        "212936d2f3c6d162c694a5c42e0713c125b2c0720a777ea2a4331d5f98389832"
    sha256 ventura:       "bcfa8a4c57aa961914fcf5602e7260f0b69db140263c91c142bdd11fe9806c49"
    sha256 x86_64_linux:  "ecc3904b5fef9a53271e8eb60dec9f740a4a4b130e25f0c425391df0c59f2083"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2026-04-30", because: :unsupported
  deprecate! date: "2025-10-28", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@75"
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
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
