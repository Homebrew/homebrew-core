require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-4.tgz"
  sha256 "32c6531d59180c5a8e730f2ffbee5ecd623550886207a317769ce7d0267d939e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9863cb2e051f8b7b4ece37ecf453c4d57ef99915a0d47e236f8d86b9351cd39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b4ca42c0271c2257d1da68652023309cbaf7a45411e59fda3e214f0e2d1e06f"
    sha256 cellar: :any_skip_relocation, monterey:       "ead56f60ac28f077a748272e1bd4a769eb462f2ee877919bd22d015bc5c8ee4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "19009ef3f41fe90b0647df579a1a2065bffe7a1a67d6c32c91b7512225f16da5"
    sha256 cellar: :any_skip_relocation, catalina:       "19009ef3f41fe90b0647df579a1a2065bffe7a1a67d6c32c91b7512225f16da5"
    sha256 cellar: :any_skip_relocation, mojave:         "19009ef3f41fe90b0647df579a1a2065bffe7a1a67d6c32c91b7512225f16da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09db551a48e31d05654d8510cfb5e2c555fa4ea6b719d9e8899db72f553d2ecf"
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
