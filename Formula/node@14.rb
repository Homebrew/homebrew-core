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
    sha256 cellar: :any,                 arm64_ventura:  "42f3d06c547f9d1c73979bf34a66364c4eec90c2b3c17433fc6afebb63c42f98"
    sha256 cellar: :any,                 arm64_monterey: "75733880dc1f2e3a76cda9fca3a449fd26bbef581a0fbce655b6603c4b068b6b"
    sha256 cellar: :any,                 arm64_big_sur:  "7a678ae3eb7ebb268d4d45fd290d1654ac83cacf7a488e8c18d36ad0ed1a1b62"
    sha256 cellar: :any,                 ventura:        "e35dac899c8956b73bf7e47a973b19db6c30d454b403d89b31e27488dacc82a2"
    sha256 cellar: :any,                 monterey:       "3e7a94eca081c7a4e5ca14dc06012fcdf166b61a008cb322c890300fd9d81e46"
    sha256 cellar: :any,                 big_sur:        "50c2db74fa22da796ca51b2816ee05aeb9b33280ded088ac61fa22903afa1593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83dc3488d1df8c391298ed3b4e24cc0ed2770cb26baf726017b35c7fc1b8b585"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2023-04-30", because: :unsupported

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
