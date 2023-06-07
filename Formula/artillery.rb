require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-33.tgz"
  sha256 "012f860ceba39449d72acdda8260ae7e9ef4a4709381dac23a7984bffc321731"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "a9e63dd27bd38eb9cbf629fe03d3f6b71152e7a2efb8a413f9c15581df685338"
    sha256                               arm64_monterey: "befeba6fb58b550966fc0f42ed2769b7f27ebdbc72ea25a44cd7c65c5a3dc882"
    sha256                               arm64_big_sur:  "f7efaa67ab5e293e0bd347382fd6338a0817c4d9a8da0ded50eac475b19d3115"
    sha256                               ventura:        "ee0ecea0fc464ce8798edd390fe6712db28702f777023752bde1149a68774f7c"
    sha256                               monterey:       "d89ff677d1b88385313a7a32fff4849222325ff3ecb50a82f3b804bd6b0ae79f"
    sha256                               big_sur:        "c1aa9a8f75ca554fb45d945f3036b5be0ffb7e295d0a57ab6a7af33eb4f639b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2b516666e7e5d5ca42a71c556fc64ca1e12353b5be59a64fc60d454b4886cd"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules/artillery/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~EOS
      config:
        target: "http://httpbin.org"
        phases:
          - duration: 10
            arrivalRate: 1
      scenarios:
        - flow:
            - get:
                url: "/headers"
            - post:
                url: "/response-headers"
    EOS

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
