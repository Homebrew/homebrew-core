class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.22.tgz"
  sha256 "4cd54217a4024da7d953e7258d7c02d309bb7db6bf9b630ee8cfd15675655721"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia: "18e367a6dbc8dee58671b9a885f694284893493b45d4b692c66b3734af65f8db"
    sha256                               arm64_sonoma:  "0aeea463a5068167ea244a2866d91b039088529399f79063483c9a9df76ad2fe"
    sha256                               arm64_ventura: "da5a85b601ebbd27bf1689902ff0d0122393881294510265059fc1012cdf607f"
    sha256                               sonoma:        "0475d0998555c0b01a3b1c7817fcd046617702f977cbac92bad7f3e847ac7d1c"
    sha256                               ventura:       "208f1c86bc65e2f56b9052a277b2bd04b547315201ae650d9dfaa0c4800b32cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9eb04cf795a5881712446b67f2d563bea10f2ac2b751b57ca596e01117edaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0579e9a607b7a09eddcf8001c3449b134cbf1cd904053600272fb793ded88de"
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
