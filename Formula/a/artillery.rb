require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.10.tgz"
  sha256 "a22ba3b6297a3babcefc218442a800daef4ecf1db377d10345156fa13e5a0d98"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "9a084efbae1fb565c0f8f6ec2427e42b197a8e55f55680309ed14c35720d5f7e"
    sha256                               arm64_ventura:  "93d06e9fad1bafd8721fd549a78ff4c06b4c2b534f995c929d4db131aa5cd825"
    sha256                               arm64_monterey: "0ed98577b32a6dc3d2de2cfdc973a594a44c4cb1fa20457716f0fce2060ff425"
    sha256                               sonoma:         "e31eda34ab3b164a61aac217447e56bca2d002f5cf78fb2308c8c45d9f089e79"
    sha256                               ventura:        "1a0326a486ac63cbe62f9a5b9988a80c174e0e07ea6f2ba469a8f0f9e8f085f2"
    sha256                               monterey:       "8277b8045e0f251ce46b3f43aeb1d5f47e0b4a568e2b47db8de1ffafba168fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b3103ab9a0550ffc2addcebb04ed8a64e636d63a45c62749e68c0f809a6f10"
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
