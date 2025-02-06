class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https://www.kubetail.com/"
  url "https://github.com/kubetail-org/kubetail/archive/refs/tags/cli/v0.1.1.tar.gz"
  sha256 "d318779a3aa5850a7c605e264fc7602543191b2decea9e7250b36729bc0ef9d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d90c4cd777200f91670e2eca94bd8d4c57d87d8af9095f14b387766834527f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45d76bdb75cbfc0345bf1d5764ce5204b38b7bf210c83d43c9cebd0373a9a46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "322075469064d6a21e30429914cc11a57a1e2efb94984f12b02808bfdb39e45a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9133ef47c3bfcbec4d9de05e4933651f8f3c384960938e5ce71fd0f493472ad9"
    sha256 cellar: :any_skip_relocation, ventura:       "4ce15c57452b2d4ca7d6f27b0a5d36599ee2b64b6d90b0e9e14858e9a0b06a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4df9fff8ec4eeb025de1da5d3a44a6bf722bb6e70e18692db25c4f16f3e804b"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/kubetail"
    generate_completions_from_executable(bin/"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}/kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
