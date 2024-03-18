require "language/node"

class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.8.tgz"
  sha256 "2333a2c58333644dd4479582e0f102378679cd45dab426efa874348787d87a4f"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "127b2d8c9c1c9cf458d1066e7d9c13b7175be85d7ca481fce4aff784ce68592b"
    sha256                               arm64_ventura:  "09ae8826972fe05be283be3e3df47d9cf655137b9fc0a32ef6e42a5bd50bc23f"
    sha256                               arm64_monterey: "fbabe9004d5affd8605dcccad940ee5421e3c30fbc6014b8e227ef5efb882b11"
    sha256                               sonoma:         "8a52616610e7b16878a89f60365ea7a25a80666ca42ca34231d5388534b24db3"
    sha256                               ventura:        "a8c1064f2fa85542d10d228adaf1998919509bda5a6e1ff06655406da4bb96cc"
    sha256                               monterey:       "4ba5d878e66b78a3856e0fa55025e262ca2e42a3c8116d6a7165097c6f15bef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da3847504cdd5fa94640aa8c028227665a3f944ef855dd4698e402c8b526a70"
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
