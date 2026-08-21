class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.34.tgz"
  sha256 "ed6ff0b9cec653120805889eb0504bde36e923fda24dea817f2691af4ccb1188"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "9356f86944c290f43571caef54cc62c811eedfcdd29e37fb31ab0937c6ad07ac"
    sha256               arm64_sequoia: "8dd6f1c91a1fe2db3e79af9a7b55c6c6d919dc55964190edc8bd73a861599f4b"
    sha256               arm64_sonoma:  "60a06adb6b5754ad2e2ac2efb36c3302db569d1b7d6b0bdfcdb78d9c3a463e7c"
    sha256               sonoma:        "fb32c6a0705abf30488f61646f9175ac9ed5b71df90f0896b65b0aa4ea3f4b9b"
    sha256 cellar: :any, arm64_linux:   "117937619256373c888b6a8438c77ed67f3fba0cea02faff2f51dfd7847a981e"
    sha256 cellar: :any, x86_64_linux:  "28f9632feafec5a9f0afd58f8584f54b0cee8019d7b6066b729de37f324d6b96"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
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
