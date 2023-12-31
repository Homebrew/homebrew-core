class NodeAT20 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v20.10.0/node-v20.10.0.tar.xz"
  sha256 "32eb256eebd8cacd5574e6631e54b42be7ec8ebe25ad47a8ca685403bad15535"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "a263ababab8a0ad1ebb1d9bad367f84a07946e61f461f260a27057ced15fafe4"
    sha256 arm64_ventura:  "5658bac00492f8857928b71f0370801ca87e1f90077436ed864c9d5dbc6ee31e"
    sha256 arm64_monterey: "8a0c7312c216cac28462ff223cfe756e9e1fd8eab86c9b772ee670269d5654f8"
    sha256 sonoma:         "b1c9dd1d7f9d3b0336568be4b851b8635f562f9633a3f13ab6d0c568859e2775"
    sha256 ventura:        "7597b64548e68cf659a451df5eab494f31560c56148cbd2506503ff544d7ea70"
    sha256 monterey:       "0368ab30fead76269b96c7ec48c929aa878a0e4247d6737889e3fa2428aa6258"
    sha256 x86_64_linux:   "f9214c620b471c180a7155395bda81faf72f8a36c6ec7e1552fe53a41bdef0cf"
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

  # Support Python 3.12
  patch :DATA

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
