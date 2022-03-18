class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.19.1/node-v14.19.1.tar.xz"
  sha256 "e1ae09dd861ab39af04483bb5c0fa54ddd82b6b15543be9a27ea6704a8ba9dd9"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b40b066d32d9fbb21a951706a57cdb849ef71bde1d3609f1fea8b9c0839b2948"
    sha256 cellar: :any,                 arm64_big_sur:  "783321851bcd89037838653d3f93f9475e45b19cff5623bfd95236e92ce4cd9d"
    sha256 cellar: :any,                 monterey:       "f26ed399312abf65e601b65f2691628b61416dc5029737b4ffeaa8aa7936206c"
    sha256 cellar: :any,                 big_sur:        "ce8641bb1c3f21741bc9febf72c06eba4691f58ed82d0858775fab350d27a22e"
    sha256 cellar: :any,                 catalina:       "ced3b35b9617887e2de6daaf433a4b2d0040c5d8a2a5a9542cacf8e7f74e7690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ffb157896a7868e80add0dc0de015d8dc216dada3d0b9c5ac852536d779d3f"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "macos-term-size"
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

    term_size_vendor_dir = lib/"node_modules/npm/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
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
