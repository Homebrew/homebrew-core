class NodeAT18 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v18.19.1/node-v18.19.1.tar.xz"
  sha256 "090f96a2ecde080b6b382c6d642bca5d0be4702a78cb555be7bf02b20bd16ded"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(18(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "b32bd98bf6a4b06c829aaa4097616f0e85bd4d9d0b6fa68dee52050c2327d5a3"
    sha256 arm64_ventura:  "29fc1adcb64f78e3daae24798d767b91e157fbff6ea37d86c46c387b4c2b9d75"
    sha256 arm64_monterey: "721cced0b0dce3dab64b3e1c62dcd82417f1edddfb37a9bf50ff6c45517692a8"
    sha256 sonoma:         "2e57cf59bf2b54f8ec568852d02478752d1cb45ac0a9e984300e4812ab902d8a"
    sha256 ventura:        "ba751532db0563332c7ba40936e7917ea6b5c99d96f23c467aa5c999f3a9682a"
    sha256 monterey:       "605613c071a43086bcda5f61b2cd3e3c35b8cefb9423b8cf51aca103d361549f"
    sha256 x86_64_linux:   "8262eed53966eea4133b9dcdd030c544b5019ff16120f9f16c39ac9a79e0e916"
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

  # Support Python 3.12
  patch :DATA

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


__END__
diff --git a/configure b/configure
index fefb313c..711a3014 100755
--- a/configure
+++ b/configure
@@ -4,6 +4,7 @@
 # Note that the mix of single and double quotes is intentional,
 # as is the fact that the ] goes on a new line.
 _=[ 'exec' '/bin/sh' '-c' '''
+command -v python3.12 >/dev/null && exec python3.12 "$0" "$@"
 command -v python3.11 >/dev/null && exec python3.11 "$0" "$@"
 command -v python3.10 >/dev/null && exec python3.10 "$0" "$@"
 command -v python3.9 >/dev/null && exec python3.9 "$0" "$@"
@@ -23,7 +24,7 @@ except ImportError:
   from distutils.spawn import find_executable as which

 print('Node.js configure: Found Python {}.{}.{}...'.format(*sys.version_info))
-acceptable_pythons = ((3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
+acceptable_pythons = ((3, 12), (3, 11), (3, 10), (3, 9), (3, 8), (3, 7), (3, 6))
 if sys.version_info[:2] in acceptable_pythons:
   import configure
 else:
