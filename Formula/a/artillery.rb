class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.33.tgz"
  sha256 "152fd876a408622e14fe62c1542cab4b164b197ff72448d14cad6b7546235c15"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_tahoe:   "3daa223a0abcaa9330149d087d7ec85f76c25d9e5959e3c7cbd49c93a6d2aa5b"
    sha256               arm64_sequoia: "c74f8e014b900136d56be84fb5d533a6fa937f5b4bfbad73e717c95cadb9b23f"
    sha256               arm64_sonoma:  "8b8cef3fce08853ca9f5f2f2e1975466dda7eb7960b9252bf54c5d7f0928bb29"
    sha256               sonoma:        "68fcd65103bdcadd67b691f50c39a6c891f208c4709510303c26de2fa92a2f33"
    sha256 cellar: :any, arm64_linux:   "09b3946db26bf9c0c85a54aa03312e842ec01d614c7293bda262996f05431cf5"
    sha256 cellar: :any, x86_64_linux:  "5b431dca4ebae8944de0b76584292174d47f1598bfda3c03d636aa71f5553833"
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
