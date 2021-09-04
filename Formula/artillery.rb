require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-1.7.8.tgz"
  sha256 "e96d6b70a0d1cb65b0ab17352d55bce7cd3cf069119177fc5e81c16151dd884e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3324fb93bdbf1686c3777ab65d14c42671c24677826603cef224d4e727ea6bcd"
    sha256 cellar: :any_skip_relocation, big_sur:       "7d3d8a7b102377f06edb47e5ce15769f442670b95c38dd2fe1d8924f5c3aedd3"
    sha256 cellar: :any_skip_relocation, catalina:      "7d3d8a7b102377f06edb47e5ce15769f442670b95c38dd2fe1d8924f5c3aedd3"
    sha256 cellar: :any_skip_relocation, mojave:        "7d3d8a7b102377f06edb47e5ce15769f442670b95c38dd2fe1d8924f5c3aedd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee92bd41736db594a7d2439fcae1159ecda52ccbcc01399d3be5f17b00c2754"
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

    on_macos do
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
