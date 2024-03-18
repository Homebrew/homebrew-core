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
    sha256                               arm64_sonoma:   "8d348f5926ded1c83687d3056f7c6b2f2845aa52895af84535aea17a4696bd0c"
    sha256                               arm64_ventura:  "deb0aa70bff4972f370292ac9ca567f68d2fe8ad637d4bcd3b10afaed48182d7"
    sha256                               arm64_monterey: "20b56879f97fae87bb5136b7334cef99600cf7932959873b4418b430b844b10e"
    sha256                               sonoma:         "a1637b690244ca807865d680417de0b1b3757493de5780a9217bdf84438d3b01"
    sha256                               ventura:        "beba2a517e5fd23f9df42ca3387e0ea8bddf48b423415d6be8d2b8d3207eb7b8"
    sha256                               monterey:       "7728065b93a97003171562c24a651439777cbf3b147e453286b05b31f0f56ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf3075260db32ee70a7012128d117ab892177f2faa559bf90151aeba5abb5bf"
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
