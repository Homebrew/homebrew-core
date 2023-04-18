require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.0-31.tgz"
  sha256 "c5c1a6b870dffb8a3f4c33b109c71f5029989fb747f4ad7825039c90dc2ae964"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_ventura:  "05693e7de600ec902ee9ae26b7a4ea847e6359eebf468d90bcb0fb280909439e"
    sha256                               arm64_monterey: "07eb21343cc3416bdf9ccfd8d999a7a529dfeddc725289a5cff00f2de4f3e609"
    sha256                               arm64_big_sur:  "96108077493be546650732f264e870f9d200aebd5813b2d16c45d79a520b39b6"
    sha256                               ventura:        "45fd5e929c79f9abd2cc26e948b9078d7800c8f1c964527f5768a6a95e7b2ca3"
    sha256                               monterey:       "62d4726bd184b1c85ef46ccf8457fb9eaca61b9900d90eb6d0b797247cb3b502"
    sha256                               big_sur:        "80e65bd1bf81eb502f8d8201b55f2149f6eb39eb6d10e7b2067a309cfe80f4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aca58924856241bf03fbe9f97a1cb1e984ce9cba0030629fa0a88781171b00dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
