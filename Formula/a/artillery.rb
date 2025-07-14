class Artillery < Formula
  desc "Cloud-native performance & reliability testing for developers and SREs"
  homepage "https://www.artillery.io/"
  url "https://registry.npmjs.org/artillery/-/artillery-2.0.23.tgz"
  sha256 "56fee81d5f5fd831fcc1e89c6134b2294095ed0c07c225578ae932b0e82b272b"
  license "MPL-2.0"

  livecheck do
    url "https://registry.npmjs.org/artillery/latest"
    regex(%r{["'][^"' ]*?/artillery[._-]v?(\d+(?:[.-]\d+)+)\.t}i)
  end

  bottle do
    sha256                               arm64_sequoia: "5c9b0f3df6e260876a412bf1439011cc80e7c0c53d6f583dab10a9d7e96de656"
    sha256                               arm64_sonoma:  "2debcd213bc15422e7d14a865e60882d91f3647e1b73dbb4d6f05dab7ba3dd38"
    sha256                               arm64_ventura: "5abfad7cb7e2c4665c742813dcc84eb3d97a1732f067378514326a1f9da9c972"
    sha256                               sonoma:        "5fd036f5003839c2e56a884c1adeac468ecdf4adaf5e742ad1e15391de14067c"
    sha256                               ventura:       "58c94545760f40d8856ca78829adf823f50735e64e5e0cc69c584da30188d149"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "559a04c716334c1cfafaa3038976de4c00b9ff9c3a80f7d3a90dbc38e5fc6091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b97f42ebe125135855f1a17bd2d408f7d30a6aeb6be1a68475ecbfa480d49f"
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
