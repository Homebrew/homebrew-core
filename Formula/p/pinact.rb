class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "2b47c1d6fee9b41a58e21d1d9452fae7434134637472e80e499490079922f389"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e3cf9e0c727a364e9cd161cdc0f42280bc0469b794f932c5ff8a3a727491dac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2d9116a18e4ea598c6be98753d56b5a5d6fab0824bbd3f52c8489d81342f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2d9116a18e4ea598c6be98753d56b5a5d6fab0824bbd3f52c8489d81342f8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa2d9116a18e4ea598c6be98753d56b5a5d6fab0824bbd3f52c8489d81342f8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94deb0851fff9d0d0bc1aa2c69c365fd36b8db031de05e67d67386db8dd05c3b"
    sha256 cellar: :any_skip_relocation, ventura:       "94deb0851fff9d0d0bc1aa2c69c365fd36b8db031de05e67d67386db8dd05c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94f6d8cc146f483b4bf1cf260d6ec023e6a49d56dae26c2f3c4cd8cd8b6a7724"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
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
