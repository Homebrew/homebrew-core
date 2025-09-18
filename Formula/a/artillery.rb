class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.24.tgz"
  sha256 "a4c43512be56332e5cbbe60502a8c43c9917db1365d3df8a03318a32aa6cb382"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "3e234cf4f1b41c7f357e15b33c57fd20efa3629bfd3c97e874396f10f1ae1944"
    sha256                               arm64_sequoia: "14ab552ddb0ecf14866f2181c6ab8f844188019bd1a2aa461a83aa0f17a295e3"
    sha256                               arm64_sonoma:  "aec786ffb55870174280c55a6e8677f3b0298964753cfc629324585007f44941"
    sha256                               arm64_ventura: "585746e826acb5003ca9504f1399ac85a26bcf1288589b84c113272afd6ddeee"
    sha256                               sonoma:        "5e8ddac5df2a31ee82b1742c72d99c8b87bce9343abe5150068adca7c2f197f2"
    sha256                               ventura:       "94e1e3dcc221e80560faf9b300e5ba8f77eb7c95f836f3ec998e0435ee8a33d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de854c6d233c00562e70e4037b1cb3786e215a21a298361d54170bc5bd1eae0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497db5375a6914736d2ca7bbf176d53df64ab7f2c77b2e1f9b91649191552f26"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"artillery", "dino", "-m", "let's run some tests!"

    (testpath/"config.yml").write <<~YAML
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
    YAML

    assert_match "All VUs finished", shell_output("#{bin}/artillery run #{testpath}/config.yml")
  end
end
