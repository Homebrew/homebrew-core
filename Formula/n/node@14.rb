class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.21.3/node-v14.21.3.tar.xz"
  sha256 "458ec092e60ad700ddcf079cb63d435c15da4c7bb3d3f99b9a8e58a99e54075e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1148f4bf7fc8f4a6cda00b7dace952ff0c9d22ddb117a3a0f1bafbbc97bac1a6"
    sha256 cellar: :any,                 arm64_ventura:  "375c56e159dae0a184d80538f902025b58f04264e9d95e461801383ab6b7b815"
    sha256 cellar: :any,                 arm64_monterey: "b795f035c842b8c1650606233931d489dbf9263cc9ddd42f2ef1bf462ec76ff8"
    sha256 cellar: :any,                 arm64_big_sur:  "c4518d76463598df942c8c38d46a2d7b712ae3aafcdbbd834333ba8fd71f6766"
    sha256 cellar: :any,                 sonoma:         "98e729af3aa9db45c721b6b7785267288ac05489d62e5a4b28fc701045cc5aa6"
    sha256 cellar: :any,                 ventura:        "ffac9ca4317a5e848f983670d79d79cc928359747e407e505a3e4d8dbcbe6c68"
    sha256 cellar: :any,                 monterey:       "4f487720c73e34e8a90bd68e0ddce2f6353e87f8a766bf4f51e85fe6b63fabac"
    sha256 cellar: :any,                 big_sur:        "96cb95fa7924ca1ccea5c58417764b932d479cc419a5f6dbdce24a82ac94823f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3deff33f7481043999a739ec048b71a30c6bf7fd1179d8c58c6d2bf4eec1456"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  disable! date: "2024-02-20", because: :unsupported

  depends_on "pkg-config" => :build
  # Build support for Python 3.11 was not backported.
  # Ref: https://github.com/nodejs/node/pull/45231
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

  on_system :linux, macos: :monterey_or_newer do
    # npm with node-gyp>=8.0.0 is needed for Python 3.11 support
    # Ref: https://github.com/nodejs/node-gyp/issues/2219
    # Ref: https://github.com/nodejs/node-gyp/commit/9e1397c52e429eb96a9013622cffffda56c78632
    depends_on "python@3.10"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = python = which("python3.10")

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

    if OS.linux? || MacOS.version >= :monterey
      bin.env_script_all_files libexec, PATH: "#{Formula["python@3.10"].opt_libexec}/bin:${PATH}"
    end

    term_size_vendor_dir = lib/"node_modules/npm/node_modules/term-size/vendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

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
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
