class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.21.1/node-v14.21.1.tar.xz"
  sha256 "3db95d6ca728957bf090b6301a7a9d2d80714b2a06d898a1db65c6e42b1da7ac"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cbe86d5c0f1c021ce41529f8e335c3832b711b8687759d7f5527afb0da6fe260"
    sha256 cellar: :any,                 arm64_monterey: "5c6e81a3969c6e95c3a273697a5acf8d744f9e76d6d408e01e1a4ad1cda908c3"
    sha256 cellar: :any,                 arm64_big_sur:  "868acabcda32d060dca96f1b3299f3c35fde3e37ab68c0f516636dca0d9027fa"
    sha256 cellar: :any,                 ventura:        "a8f01ea53e89d6d995a6153b4dc028554dbbb28dd233a2b4908ac5b5ea4ebfd6"
    sha256 cellar: :any,                 monterey:       "073257f3276e543a37117aa9d5553b9383607c1168c82f9b330f3d50ff86b4a3"
    sha256 cellar: :any,                 big_sur:        "61f063876cbb7b3c8222116fe977fa6354caea76a5a697e148b2324755718d66"
    sha256 cellar: :any,                 catalina:       "2b6f03f7caaea96b27fad538ec1600c0c7619195ee16c53a7d81081d6fe0f185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31700b31d1d02aede35bb5fcb817667a6c12da6ca2b9e47c4a4bf25ae70a7a31"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2023-04-30", because: :unsupported

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
