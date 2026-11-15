class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "b01d407677164b59e21b3ff6f8c0bec4bfcfa42df7611c713de64c9ebf1e009d"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff38858510913e93caeb1d84b0a8bbc5677b133fe857132ad6fcf6d30b9011ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff38858510913e93caeb1d84b0a8bbc5677b133fe857132ad6fcf6d30b9011ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff38858510913e93caeb1d84b0a8bbc5677b133fe857132ad6fcf6d30b9011ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "135a5f78670cc87fb4f7932240b2d2f44f77f8db16b41169da0fb20f3af2d8b0"
    sha256 cellar: :any,                 x86_64_linux:      "22f439ee8611cd6eef077610ffbcdc945eb1de209e27daa41b69d0f6df74bed2"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
