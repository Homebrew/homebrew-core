class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.26.tgz"
  sha256 "ca5a8041225287dfecb83d4dda385e2a0e6539b9544fb8af3b6ffde5d8779993"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_tahoe:   "f2074443fca8be08e2348aec667a5cb4940f1a250a696fc1593ec626de373bbf"
    sha256                               arm64_sequoia: "162ed91c8e41ef5249e6a8e53a9572f3e14aa565fc155745bae9680109b35a29"
    sha256                               arm64_sonoma:  "26b358eef47e3bf5f1369428fb1a5e9c1514e36cb7e17267138ca9e5864070b0"
    sha256                               sonoma:        "0fee749e63a4972e299d0c42aca8dc31f4e49fbd52054c80a90a21aaffab131b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f91181e8ee35c15ce8cf99015937e006d538b02a59133c4f4b726f67443e1a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e97b9cdeff224eeb42b67d0ac8d2ee155e4d81850eea7cd41f5fabbfe6bf23"
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
