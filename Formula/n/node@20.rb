class NodeAT20 < Formula
  desc "Open-source, cross-platform JavaScript runtime environment"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v20.20.2/node-v20.20.2.tar.xz"
  sha256 "7aeeacdb858299e09a3e0510d4bb8b266923894a9e3ac0058ba89d4ecf4a4cca"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(20(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ecdcb6357c02e973fe7bed1b85fa142166e743aecde394046a4278e8d7acfa65"
    sha256 arm64_sequoia: "76829440870e8535079d7b600a15e3c2c66f31499981ac91bd4f6b7a10af91ed"
    sha256 arm64_sonoma:  "b85e5e17778b5d29753616507b9c54bc1a98f07094f1deecd829b1310098f0f2"
    sha256 sonoma:        "51df24b083cec403185e1cc43b79e2845600a3c8936340ae6578cac011b6ce81"
    sha256 arm64_linux:   "220c54e9d8cf434846cd20392f6e73b156e5e67a51f1b24d99fa70585579dbda"
    sha256 x86_64_linux:  "6f741ad57671a0997c93de0bbfeef6d22769eadd7de4ca6f333aeedbfc901f8f"
  end

  keg_only :versioned_formula

  # https://github.com/nodejs/release#release-schedule
  deprecate! date: "2025-10-28", because: :unsupported
  disable! date: "2026-10-28", because: :unsupported

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c@78"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # The new linker crashed during LTO due to high memory usage.
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3.13")

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
      --shared-openssl-includes=#{Formula["openssl@3"].include}
      --shared-openssl-libpath=#{Formula["openssl@3"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]

    # Enabling LTO errors on Linux with:
    # terminate called after throwing an instance of 'std::out_of_range'
    # LTO is unpleasant if you have to build from source.
    args << "--enable-lto" if OS.mac? && build.bottle?

    system "./configure", *args
    system "make", "install"

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
    assert_path_exists bin/"npm", "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system bin/"npm", *npm_args, "install", "npm@latest"
    system bin/"npm", *npm_args, "install", "ref-napi"
    assert_path_exists bin/"npx", "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx --yes cowsay hello")

    assert_equal HOMEBREW_PREFIX.to_s, shell_output("#{bin}/npm config get prefix").chomp
  end
end
