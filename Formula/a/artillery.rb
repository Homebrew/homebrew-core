class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.30.tgz"
  sha256 "b8b31e668aa0c2def8d68fee2fa84d614bcd317dd723aa9d17f34aace90fba83"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "2d67e55ae0cb1e756ccea64cb6fe41106a035ffe4985aa4e90d4557c173c5f8c"
    sha256                               arm64_sequoia: "aa1435921b1508911cf1d10b0edc0ba12e5a88321741b98d83e274799a09264f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5aa683624d6b88cdab5c28a35928f7011322da1df19166f2e0873691fd551fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5aa683624d6b88cdab5c28a35928f7011322da1df19166f2e0873691fd551fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48d519aae715fc76c92c164c24bc13919822974993be9e71d1c27b82ed50cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efdda745ed5a0a430718bb00c347306879676ce516afea92e010bf0b9ad440db"
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
