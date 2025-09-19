class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.25.tgz"
  sha256 "bf1ac1e41d3eb337e2f6d66c39144c1e60fbaaab622604cf51a06beb6cc9d905"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "b5cb57035cae633e56767202f6c42d4ccdc5c7a195089c8fb682be21fb0b4261"
    sha256                               arm64_sequoia: "d63723495a9b9dcfceb0238ea15f2c663074e22fd6598479586c14e5a6f068ed"
    sha256                               arm64_sonoma:  "48330dd76ca2cfbad3027b2cdb3b5f9671a2d5b165747f25510e3f17c56e96f2"
    sha256                               sonoma:        "e6f4be4fa3ce7d6c43b75b61273fa382fc05bfa37a22548771345fcb08412e04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacd17a3186309f38c37cf910e56222b0760299ec0254e2d7b1b1d36b7335317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65a1f95bad0f246ce7143633c7573b6e1418863d528c2670b7bdb08bd4597eae"
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
