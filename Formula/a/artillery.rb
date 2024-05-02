require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.11.tgz"
  sha256 "3b7be31e27992dc4d99d72ff4825ee1e4150b318cfe0227595dc09149c2002f2"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "47e9b1e132808d715bd1d7f8bce34ebed1ed54aed1214acc6670c538ab2e006e"
    sha256                               arm64_ventura:  "5f8712aa11371031ae7c8d0bbc157ef3d713b1acab1437d7c40806703d087efd"
    sha256                               arm64_monterey: "18ff11dcecc731b3dd17630683c05308e5ee6f6e4ed1d51f0f672801b3e1c567"
    sha256                               sonoma:         "c4bce93bf697e497c352233f61fd2189b09a28d9245eb1317354569128b15e72"
    sha256                               ventura:        "9fe6e622d64509dc953a0d59026f85a6fd2161ff2fae5255050ff700603aa299"
    sha256                               monterey:       "e305190f085fe74d018a1d3d7b92e76838726f6eb406429df03c882845d0c814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49749fdaaed359d129e559e96c02a06b09df3af3c0eba88a072e4e6f85843d3"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
