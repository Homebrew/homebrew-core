class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.19.tgz"
  sha256 "72da0d609c219a9da05cbc6e18684730344aded8a191de7ae8fda24041522af7"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sonoma:   "a1c65e5198a522567a6304e5e7d68e6a16ac1a3cd26c89c586c388c48fb18915"
    sha256                               arm64_ventura:  "d614899b52e0ad4748ae2db47072b86204b8dfebf85385346bc6f36a7ac86902"
    sha256                               arm64_monterey: "095e0cab2cbf6074de8565eec55bc82562049a5c897676705b6d82a9c5d94067"
    sha256                               sonoma:         "9bc9f5b3b952755e6f47155b4b9f40a54070c44df7b5cf23277fa170feb8f99d"
    sha256                               ventura:        "f9262b64d9fc141ca37c7409851e6d4060d11c4b14477abee3acb8d3f3ec1938"
    sha256                               monterey:       "d6ee5c4fabb836720bccb100bc3a7410825dc4b0b033b133f29e31ee6a3378c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665ea1e9a86e7c1da1402984a5b9c3ffc5d9fae2046d17be8766ad9651fea51d"
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
