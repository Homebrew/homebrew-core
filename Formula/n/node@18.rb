class NodeAT18 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v18.20.2/node-v18.20.2.tar.xz"
  sha256 "8aaea7c9c7e927fb09d91498da311b6e4d18233390e23c723a53b891fad4c73f"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "2ce8a561e75498dc227f9546c9cb444c8d84b98418098cbbb5d082283a809a70"
    sha256 arm64_ventura:  "1b7dbb122f27c2d6e0d844d9ccdb936717cc5def1f608f41a67bfc0094f3ca05"
    sha256 arm64_monterey: "c86ca9997ab9f8762e0f6e0e69aa81774a5666cdbea4504ce17bbee4439eb42a"
    sha256 sonoma:         "2314bbf7de1c0054b41b679b4ae3ea1693c8eb0a283d77a966ea82486597ca41"
    sha256 ventura:        "e1847c1899ac853c5a5e931a5fdfac063b26a62c27345a557af6bc5b0bd0513a"
    sha256 monterey:       "05a174513f3d6d62f58186f30956d1f6538525d4540029e9390beca7a49fe634"
    sha256 x86_64_linux:   "f192a92d9cda4632e45924c1e192010bdb0133e36d0c40c0eaab6f018f121a94"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  # disable! date: "2025-04-30", because: :unsupported
  deprecate! date: "2024-10-29", because: :unsupported

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

  # upstream bug report, https://github.com/nodejs/node/issues/52230
  # and v8 dep patch PR, https://github.com/nodejs/node/pull/52337
  patch do
    url "https://github.com/nodejs/node/commit/f7a319eb22d956c11c71fd203243c3fb7fa2094e.patch?full_index=1"
    sha256 "e410e1abe96bc23b4dc8e308cdc93fc3e940b524bcff78d5a4c15f64b2e075f2"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

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
