class NodeAT18 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v18.12.1/node-v18.12.1.tar.xz"
  sha256 "4fa406451bc52659a290e52cfdb2162a760bd549da4b8bbebe6a29f296d938df"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bf34d35dae54f4d6035aed07423a42e803efbcfce8f29f3fd01d74518a01f85"
    sha256 cellar: :any,                 arm64_monterey: "6c1c1cf91bcaf70002531e6f29ed7b30b28dab4b197d6eb2f401b863b803ca2c"
    sha256 cellar: :any,                 arm64_big_sur:  "8babdc71177ced262407f0e05bf951050b3c26f5f2a55aa8195635019e273506"
    sha256 cellar: :any,                 ventura:        "46bc8300ca83d75435ea10597acec3b8695e688c2b04a2969e60266745bcff58"
    sha256 cellar: :any,                 monterey:       "86177e9684caa0c024a4c8cdb478148b5e9ea0e699a1a31fc555beef63bd2ced"
    sha256 cellar: :any,                 big_sur:        "f261760bbd78db651bc9a2756695db3e44cd4b8edf6a8fda25f88de77f2dea37"
    sha256 cellar: :any,                 catalina:       "6c09a8e9bc2bbc96e2508a36881f6a15df5cf4cd476371fc8fd120eca1efea3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4237c87c7a25490dcdb1c56d8ae5024478394349a9eb4be00d6da5320cd3959f"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2025-04-30", because: :unsupported
  deprecate! date: "2023-10-18", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

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

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.10")

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
      --shared-openssl-includes=#{Formula["openssl@1.1"].include}
      --shared-openssl-libpath=#{Formula["openssl@1.1"].lib}
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
