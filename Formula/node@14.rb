class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.20.1/node-v14.20.1.tar.xz"
  sha256 "365057ea661923cbfa71bdd7a8d0ace9ddff8d22d431ad92355f8433cecff14d"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2fff457b29cafd78671a8860e2bd945e8d90e24075957dfd3bb130a48938467"
    sha256 cellar: :any,                 arm64_big_sur:  "b97b63612564750924571a1c70972d765c8831db144ce220cd20385bbe526293"
    sha256 cellar: :any,                 monterey:       "00d40002a5261bcd0219d8bc633dca75641c9aaf6392e920139f10b097019a6c"
    sha256 cellar: :any,                 big_sur:        "51608493843eb94c8e111c89a4b70b63df443729abb5f42a111ccf268c2be6af"
    sha256 cellar: :any,                 catalina:       "82354b2e4ba958a5567dc5f6ec91411dcf1023f19519ce6c0cb0ea544bd60c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0991e3978cd3b9d81f5070eac74aa4f3be74b209f50f9a930b4c414f01e3d2"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "python"
  uses_from_macos "zlib"

  on_macos do
    depends_on "python@3.10" => [:build, :test]
    depends_on "macos-term-size"
  end

  def python3
    Formula["python@3.10"]
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python = python3.opt_bin/"python3.10"

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
    system python, "configure.py", *args
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

    # make sure npm can find node and python
    ENV.prepend_path "PATH", opt_bin
    ENV.prepend_path "PATH", python3.opt_libexec/"bin" if OS.mac?
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
