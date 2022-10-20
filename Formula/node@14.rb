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
    sha256 cellar: :any,                 arm64_monterey: "ea3c7d7568c16945e6a388b0ed46dab14fc460b1c7b4d7b4ec30241d4ee3890a"
    sha256 cellar: :any,                 arm64_big_sur:  "601b8b07f487122116ae045b539564a14829ee4277b4a1e631fe16825e56d491"
    sha256 cellar: :any,                 monterey:       "b083b00b1821587636cce2672e6335acc4d416eb244c56a6e402abf2f40d3ac3"
    sha256 cellar: :any,                 big_sur:        "fbc4ad6b7fca7565e6a686feacf06f382255efd3d1564af8d961aa0f60dac3fc"
    sha256 cellar: :any,                 catalina:       "2cadc6a67a62441d2b2d60069b02420d5955dc8b448563beb81154671b1fff03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27c46f5181093bf0396c607b1af744bf4aa9688ac2a099c043bf617f401df554"
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
