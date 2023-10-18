class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.20.2/node-v16.20.2.tar.xz"
  sha256 "576f1a03c455e491a8d132b587eb6b3b84651fc8974bb3638433dd44d22c8f49"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "27070fb9275d5dd1d4bf816659705acc1048ff947a30cc6b0816900d198fab69"
    sha256 cellar: :any,                 arm64_ventura:  "6712e525f435f790df664cf063b18f85973043f8a3817e14764f0e73ba3d14ce"
    sha256 cellar: :any,                 arm64_monterey: "d6849c663947a208dbb494be1433ecea9736896988b7078d41e3ed002eb3d0c5"
    sha256 cellar: :any,                 sonoma:         "5422ad0692efb86e6499645e9cc91de15ae688d426991ae24084fe89a76394c3"
    sha256 cellar: :any,                 ventura:        "8a163469a0ee7d005efc9ded82e6de9fe80075a207aaaff6c69b675c3fe2e17f"
    sha256 cellar: :any,                 monterey:       "7c3eace3570476ba69a6922f1de10dab934112fbf5c5f7ae7a6f1b3f30518f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ade4824e8c644789ac5dcbe03b5e58cf6f07915ebe22771de948a159dd05da9"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2023-09-11", because: :unsupported

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

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  fails_with gcc: "5"

  def install
    python3 = "python3.12"
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
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", "npm@latest"
    system "#{bin}/npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")
  end
end
