class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.13.0/node-v16.13.0.tar.xz"
  sha256 "32114b3dc3945ed0f95f8bc33b42c68e0ef18c408cb56122572a163d907ecbcc"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcdf255a4d63c2b755acfd59480b7a02c195a3c386ca20c82f26f13e205b6f92"
    sha256 cellar: :any,                 arm64_big_sur:  "e2ac62e70da685a6aadc76141c21dcdff0ba91b894b23e92bb586a9be8be84c5"
    sha256 cellar: :any,                 monterey:       "8c16a935d3dee5bdd4a6f4b0f06264d7338a60571d9fea267736ef6536326ce4"
    sha256 cellar: :any,                 big_sur:        "6b1e3bc494da5d9d9cd04bc52f014390151b600266a3bc56d4bc4f02820c5489"
    sha256 cellar: :any,                 catalina:       "a1c9d9d4c12828045abf5fa188425c9248e34329c3ce76f57905e01ec64aae98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1929e48ab8f6c793af9ee4972172bddd9a0d833ca2b57a6cfaaaa6bdef1883fd"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  fails_with gcc: "5"

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

    # Make sure that:
    # - `node` can find our keg-only `python3`
    # - npm and npx use our keg-only `node`
    bin.env_script_all_files libexec, PATH: "#{which("python3").dirname}:#{bin}:${PATH}"
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
