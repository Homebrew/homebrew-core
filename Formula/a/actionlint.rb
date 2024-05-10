class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "3f4d8ac136476efafa207c1a8ecd115e7df533fd32aa7c3d2ffd943a3a165991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70ab423bc1aa56d06e94ad8baf38e2da108839a4a3eeec95b3e49d868f6247ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60fc6d0bdddacf704a220c6387f0e7897e0a06a8ca328685b9e218d9832e3fef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d5277aa95af7bcfd6f1ed3be2aa563125c83d66f2ccefae515bf10a24c25169"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99bbf5d1868b59f633f37ad311cc5eb2c501a6e5c1ec92bf707be55dc62eead"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf9ba1a7dab0e375ba1344ea921bad5d053ab91fbe234ba62b52d8d4333a82d"
    sha256 cellar: :any_skip_relocation, monterey:       "993394b5d71989d366e46c813ed38e4e6abbbad97b79d4f577115c2f2a781f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7517cb6ecc4d4dda9af32e97a1f1ac815b3685289a674f54ec92aceecdc15d"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v2
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
