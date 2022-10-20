class NodeAT16 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v16.18.1/node-v16.18.1.tar.xz"
  sha256 "1f8051a88f86f42064f4415fe7a980e59b0a502ecc8def583f6303bc4d445238"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ca0dfad052e4717f0ef6a9d6101b97ec6a63be9eb7c4a0d6a1f25065a2904232"
    sha256 cellar: :any,                 arm64_monterey: "3beab95c662121a6d297f8e799267d8c97ed8936f1c5fbb2806b4fd235c63978"
    sha256 cellar: :any,                 arm64_big_sur:  "0b2a9fb0a9dc92eb886b91de3d48eb9f1e5cecdad0a1c01801ba13a45533770a"
    sha256 cellar: :any,                 monterey:       "7eb25934eb8b7139e9b0e68f5ce67c249f3f7226b39fc53a3a1d3f461006d399"
    sha256 cellar: :any,                 big_sur:        "5f9b8f7d8213ecec2d3b9a39efc8d6a4df8a2c3f30a32c4fefe00392f5a3f9a2"
    sha256 cellar: :any,                 catalina:       "09104ccf6ea1cd8dfe19089d2147b35b752cfa61725cb0edb971157e06f1847b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62a367e6f121ab83b95774420716099efca22e096bfbe141a9a11b1ff9b86616"
  end

  keg_only :versioned_formula

  # https://nodejs.org/en/about/releases/
  # disable! date: "2023-09-11", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  fails_with :clang do
    build 1099
    cause "Node requires Xcode CLT 11+"
  end

  fails_with gcc: "5"

  def install
    python3 = "python3.10"
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
      --shared-openssl-includes=#{Formula["openssl@1.1"].include}
      --shared-openssl-libpath=#{Formula["openssl@1.1"].lib}
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
