class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.31.tgz"
  sha256 "afd57456b425deda1543457dce1781a8113285bf07b3d1f14af3d8ab2da38d57"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "4a3e531d3c5ed41a78f6a48b41e477b4f5bc8063ae6b99996b663d7bf5c59e35"
    sha256                               arm64_sequoia: "a5561cd855cea8dc432450463b9a454af60af444af6697b0d96a78e7dc331cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3660f1c5f8ebe834b10ce4da632ee5353d360de218d48332c1b4e966782df5ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "08f717fbee123f5a172b79988546f33563fa89eccafe69de5fe6375c52d484b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00140d6500126c00f24dc8a8d6e7620dd31e7ab5a026d55e75b9ac2ec4ace4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb48b9536bccb49637f91bda1ecba04fa01766c9864e69dae7077ffaf30346d"
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
