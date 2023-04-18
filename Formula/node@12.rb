class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.22.12/node-v12.22.12.tar.xz"
  sha256 "bc42b7f8495b9bfc7f7850dd180bb02a5bdf139cc232b8c6f02a6967e20714f2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "045359c8f591ca97d2f4ab9f6348cd456331c03f68cb88913fc7724145fb76ec"
    sha256 cellar: :any,                 arm64_monterey: "080b711a20d34d0272b737fe0b764afe8e0339c6cf298faee8397a4870ac3b7d"
    sha256 cellar: :any,                 arm64_big_sur:  "535bf5c436d07b3078237460cba937124540b3fa92c4123a290b24fed6e0a0d9"
    sha256 cellar: :any,                 monterey:       "a9f6e355460a7eaa9309ae1ba8332040a51409ce3dd462ca957b80ff45c65c42"
    sha256 cellar: :any,                 big_sur:        "1f790b5c3a7cb07599d61e61be28a076d3980b14f14939d2e3f29daf5f9f4d9e"
    sha256 cellar: :any,                 catalina:       "a9544a2762f1c2fd862c44cebc867cd2e3ad97836229d5228ac4340bbd0301be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744c889c42c289732d392589d369c3c462ee83579c863375c0ec745c1e7de10a"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  disable! date: "2022-04-30", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build # fails with Python 3.10
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "python"
  uses_from_macos "zlib"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python = Formula["python@3.9"].opt_bin/"python3.9"

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
    if MacOS.version >= :monterey
      (testpath/"bin").install_symlink Utils.safe_popen_read("xcrun", "-find", "python3").chomp => "python"
      ENV.prepend_path "PATH", testpath/"bin"
    end
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
