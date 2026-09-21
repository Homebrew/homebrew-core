class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "fe9a37ca6f3e264697ba3b93ae412f88c9112e41ef56a46e2d2b25b705c7a8e0"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5bc3704f75de4338ac7b615649439d9efffd39b124976ff699aa4c0016ba1cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5bc3704f75de4338ac7b615649439d9efffd39b124976ff699aa4c0016ba1cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5bc3704f75de4338ac7b615649439d9efffd39b124976ff699aa4c0016ba1cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7bc8138de3da4e2e2f525fea3ab70862136cddce749d12782e099f6cb40c5148"
    sha256 cellar: :any,                 x86_64_linux:      "cb54357d3a2b4f6d7b2c0adc02df5cb1297235b562d0fafb9428e17a1dcca5a8"
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
