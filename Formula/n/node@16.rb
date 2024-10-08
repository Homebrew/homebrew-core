class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.20.2/node-v16.20.2.tar.xz"
  sha256 "576f1a03c455e491a8d132b587eb6b3b84651fc8974bb3638433dd44d22c8f49"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ddecac75c7cc914a727d10838f2856536f81c35b53dc2bb91ee9340523f6009"
    sha256 cellar: :any,                 arm64_sonoma:  "9262e2a60efc4c39e3520ac3a7baeb699430cf99a75e84ab86f27815068a2fd9"
    sha256 cellar: :any,                 arm64_ventura: "abb0f112bb7f62ae80e0ddbb99bb458935a737b791ff6decd8e806d294fb7eae"
    sha256 cellar: :any,                 sonoma:        "6bf19cbb09ea5274d4284e6efe276375eeb582f8e3adbb376cbe85a09a52052a"
    sha256 cellar: :any,                 ventura:       "300a11d0820826d4a6656a6012ca186fb39776ef277904ee72960d4135b401b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4859f731a7afe82b2393f76fb0f0fdf5fa880dc71307c6054e5c6f157bc57f3d"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  deprecate! date: "2023-11-02", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@75"
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

  fails_with gcc: "5"

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
