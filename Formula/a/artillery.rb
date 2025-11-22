class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.27.tgz"
  sha256 "f71f5222435159073ea016fa8a6fb72d85ffa119f0d71058db641e2613aa976f"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "ce1f89c96ef63d57bd4c45e40604bbb4c2d46240d02118444645525a6ea85034"
    sha256                               arm64_sequoia: "3c490dc4628fdb080403c57a7ae3f503097b792e0a913a27c17b07a38e9a2398"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4625e0ac3a4e4efd402fbe55248a6b497fcc6fc884de2f329416cb1fdd822c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c4625e0ac3a4e4efd402fbe55248a6b497fcc6fc884de2f329416cb1fdd822c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e40a6c18693d71709a4b50ebc46d8a9768b2f0c0ffa67ec24eb681b88136158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d4cd783bb859303d1b52f30c3406a1b44424cf97d6b6b8b59a76cec593bec0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
