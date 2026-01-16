class NodeAT18 < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v18.20.8/node-v18.20.8.tar.xz"
  sha256 "36a7bf1a76d62ce4badd881ee5974a323c70e1d8d19165732684e145632460d9"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "99e7e2eb7d40cae9e51afac2f7c67921c7a4a72100ffd3c2a45d90db142d5020"
    sha256 arm64_sequoia: "85339a0121bfd4eade3f70a49197c59fd1d0dee18511edf924d4acf4d81cc012"
    sha256 arm64_sonoma:  "cce72f3a40cb31861f419e0ea364cf0581e6f59b28f3e5c00196ccdea6a9f295"
    sha256 arm64_ventura: "abf275d5c731c19cc83cac346960ee3d53e845c35e1cb04278d31e26a9aad9ec"
    sha256 sonoma:        "5d6cc20ba0c4f0e75534b961530c236222d2f11b8fb5dd890f0f2f7d71d778cb"
    sha256 ventura:       "979121dc9e057de08c03b75690f3111b7d3bfb03974299bc340166441f0a3ce8"
    sha256 arm64_linux:   "006629948d696eaebdc65531418f095b71e4f3fd66e966f594f61021137c771c"
    sha256 x86_64_linux:  "47a91f8bf2f6c0915eebc7793c97ea3d980d292c0242e1cc376e621fbb9d18d5"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  deprecate! date: "2024-10-29", because: :unsupported
  disable! date: "2025-10-29", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@77"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

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

  # Backport support for ICU 76+
  patch do
    url "https://github.com/nodejs/node/commit/81517faceac86497b3c8717837f491aa29a5e0f9.patch?full_index=1"
    sha256 "79a5489617665c5c88651a7dc364b8967bebdea5bdf361b85572d041a4768662"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix to avoid fdopen() redefinition for vendored `zlib`
    # Too many commits to backport, so apply a workaround
    if OS.mac? && DevelopmentTools.clang_build_version >= 1700
      inreplace "deps/v8/third_party/zlib/zutil.h",
                "#        define fdopen(fd,mode) NULL /* No fdopen() */",
                ""
    end

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

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
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
