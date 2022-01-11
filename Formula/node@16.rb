class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.13.2/node-v16.13.2.tar.xz"
  sha256 "98b1de1ff92a292b93d2b2c93bc2a98656647b3d0c0d5623069f4f8047a8b4a0"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da48132151b72bbc9d2b1ee1bb953b888a2d195ec23b90de0b75f9c5744c7e4b"
    sha256 cellar: :any,                 arm64_big_sur:  "b391314a1995dd9e3dc49ab7f46edbb8a697caa334c27e39a9931c1c2923f8fb"
    sha256 cellar: :any,                 monterey:       "2db7c0ef8af5546b8888126bd77d0b76f143ca7a98e35ad9598cd90b79a5c31e"
    sha256 cellar: :any,                 big_sur:        "212e8db648357a0ca7d45510fd0fa373b2c61e4bcff7eca51ea3694fe4929162"
    sha256 cellar: :any,                 catalina:       "5b4139d5d52525d1fee27fcb2c7d1f997c5de2746ef1219c46c3cb9790e529a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076cbfd7a9a35f262e60c4a88a464ea020ecee4b0590bd1654d2475e0a75caf8"
  end

  keg_only :versioned_formula

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

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  fails_with gcc: "5"

  # Fixes node incorrectly building vendored OpenSSL when we want system OpenSSL.
  # https://github.com/nodejs/node/pull/40965
  patch do
    url "https://github.com/nodejs/node/commit/65119a89586b94b0dd46b45f6d315c9d9f4c9261.patch?full_index=1"
    sha256 "7d05debcfaf7bcbce75e28e3e5b2a329fe9bbb80f25b7b721e1b23f20db4dc40"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3")

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
    system "python3", "configure.py", *args
    system "make", "install"
  end

  def post_install
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
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", "npm@latest"
    system "#{bin}/npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
