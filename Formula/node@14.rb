class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.21.3/node-v14.21.3.tar.xz"
  sha256 "458ec092e60ad700ddcf079cb63d435c15da4c7bb3d3f99b9a8e58a99e54075e"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9cf6e626a2a7cebf2b7182782946963719ecbe3a1d29942bd2f40b027dc463be"
    sha256 cellar: :any,                 arm64_monterey: "1305a15b95715115ea3f5e9b48fa266cf2dcdb8d4db2910fc8cd10c2f551a520"
    sha256 cellar: :any,                 arm64_big_sur:  "9cfcb5691a03459e9ea1b6bf84d2b190649aea1b8814fc3d5267eaf383f0141b"
    sha256 cellar: :any,                 ventura:        "b1392b23ec3f0b13aaa30791c76268542957423a4b43e13f9db4305a27b26008"
    sha256 cellar: :any,                 monterey:       "a996d688aa6cfc7475427a1f1806fa33d6f727096ad3715b7cfd5afbab7d48d6"
    sha256 cellar: :any,                 big_sur:        "9ab1d20189bda9d2912eda3fc6f94c1f6a832a8f6cc730f95c7c9fd9552a926d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "500ecad09e5bc920689152ca9082657f32d223543cc46af0ee91c4f84fafdef1"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  deprecate! date: "2023-04-30", because: :unsupported

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
