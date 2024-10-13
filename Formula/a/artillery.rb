class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.20.tgz"
  sha256 "713783333e11925f88035e4b5fdf5c469513e4510c74b05a23f00a6a24abee07"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia:  "132c60cb2aab3f59363f557e22a62300a73dcce246c21c3f3dccd5aa8d66a857"
    sha256                               arm64_sonoma:   "3224573b021d606afea3dc508cc7d3968a8322f6a5d38129f4fc348b29e204c3"
    sha256                               arm64_ventura:  "e3fc8d7abe2b8180d1ed515c1962233b8ac9bd5fa0307bce0e597cb019f7e815"
    sha256                               arm64_monterey: "c8975a5aa6f09e5d4bb3fbebbab2da75e7219d8835d8529b2b6b95fd8c86ee04"
    sha256                               sonoma:         "16154c49c7fa7618c6b9c2ad2fcab457d251644408be058a2f70491f39fa911a"
    sha256                               ventura:        "3d29ea1477591596d78eb80174bf50d337382cff504b2fa52b12be7d8c619393"
    sha256                               monterey:       "eafbcca6f01b320d92ede626e5a0efcc25d806fa32419e0e627d983e32137e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f8ea6ea780eafaa95c72b884547dbe80c3d5ac68422364cbecd551b144eece5"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
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
