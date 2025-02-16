class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.20.2/node-v16.20.2.tar.xz"
  sha256 "576f1a03c455e491a8d132b587eb6b3b84651fc8974bb3638433dd44d22c8f49"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b13be0d32da21d723781c78c3f5a3bdf84d86541d867c99944ce845752efb7f7"
    sha256 cellar: :any,                 arm64_sonoma:  "77f8dc24029ff4a327a08e34ca03b9bffb2d2af3154a72d3e715dbdbd5dcc056"
    sha256 cellar: :any,                 arm64_ventura: "4684f8478761fc02996757f54c0e8cd1f1b8f8a91919048f6759e4fa09cd2e9f"
    sha256 cellar: :any,                 sonoma:        "510b6314af58d227186a4e19d056281935b7ada207a4119399d5b0b97501530b"
    sha256 cellar: :any,                 ventura:       "1c4481d6303b9e416c629879cce704d61d8ca58ddf8a37cedacd8d04b212d3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8ad6360d6350f4ea98930aa626aa0448bbd264c075959c7ad7d8940109f354"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  disable! date: "2024-11-03", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.11" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@76"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # node-gyp bundled in npm does not support Python 3.12.
  on_system :linux, macos: :mojave_or_older do
    depends_on "python@3.11"
  end

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  # Backport support for ICU 76+
  patch do
    url "https://github.com/nodejs/node/commit/81517faceac86497b3c8717837f491aa29a5e0f9.patch?full_index=1"
    sha256 "79a5489617665c5c88651a7dc364b8967bebdea5bdf361b85572d041a4768662"
  end

  def install
    # icu4c 75+ needs C++17. Node 16 uses `-std=gnu++14` so keep GNU extensions
    ENV.append "CXXFLAGS", "-std=gnu++17"
    # ../deps/v8/src/base/bit-field.h:43:29: error: integer value 7 is outside
    # the valid range of values [0, 3] for this enumeration type
    # [-Wenum-constexpr-conversion]
    ENV.append_to_cflags "-Wno-enum-constexpr-conversion" if DevelopmentTools.clang_build_version >= 1500

    python3 = "python3.11"
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which(python3)

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
    system python3, "configure.py", *args
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
    if OS.linux? || (OS.mac? && MacOS.version <= :mojave)
      ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
    end
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
