require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-34.tgz"
  sha256 "34a30972e97ceecb5f846efaa866ecbd2ff8dd4cec08a24cf836938ae43d3b01"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "873bbcdb6a53f4859498a9590d722d6b734e36c604205775055b8b59f92227d7"
    sha256                               arm64_monterey: "e8f14297800bed1b742555d257f2322b3994fb1b67af9fba86fd8a6f6799375f"
    sha256                               arm64_big_sur:  "27e4622a759e52055bddf211bd6d32789c372473f73ba26ecec7d8aed98324df"
    sha256                               ventura:        "1401e4e6d14a88fef97acd23c9015de579a7dff7aa21c1f5006b92da717008aa"
    sha256                               monterey:       "11bc395e9a70f50e68c1eaf5510030dfa762f53a43afed153a1a327ba4708c41"
    sha256                               big_sur:        "882c330a693ba85fedd02c5c81a038611b2e9314ad11a9d0ebcf3f20ddd1bb13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071d4f4dc127cbb2517efc4e44ba0a994049c5161844b57838f788059cedaa68"
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
