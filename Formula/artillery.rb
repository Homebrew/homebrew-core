require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-1.7.9.tgz"
  sha256 "94bed2af244b0e1d4978100d2dfed5ecee64f11c99d4a19a496c9dd38d9f7e83"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e2d6826445ac2658e775242a95058724fa0e8d1ba2573bb6afc13e487cf01bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "917c441ab7a5f109f002b42250d42a6065ba93a01dbc379d50ad720f29f08697"
    sha256 cellar: :any_skip_relocation, catalina:      "917c441ab7a5f109f002b42250d42a6065ba93a01dbc379d50ad720f29f08697"
    sha256 cellar: :any_skip_relocation, mojave:        "917c441ab7a5f109f002b42250d42a6065ba93a01dbc379d50ad720f29f08697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e84b54f7ed0aef5123f9bf03d126f690632a25a644c9ff12a91347622029806"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
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

    assert_match "All virtual users finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
