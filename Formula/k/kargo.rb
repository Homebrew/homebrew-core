class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "b434781bfa822e3e3520f7c48ae958466be35a352e829507551c1dcbdb3524b7"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e0899e71722bfbe0dd7c66d57f514a34ab6b5b4c3d157d04d36cbea3a74039f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babc51506af2d51162cf97cc6410ced6820caea22cdc1696e907939bd36e7115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c1d0050d8afaf95a43dbe7b6e083a0fd4dc6eb53f30e9ff29a889021f03d007"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3ed4c97a542f1fe8045e49275dc4c3ca156249245ec9a3372ad7c2e06ff721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc450c7339885967fccee09d50c79e636e3783a5b799c9a6b98a3fbcb0e4b3c"
    sha256 cellar: :any,                 x86_64_linux:  "ce1e5b4ac9293cdeb8488b2a89de5cb7bffaefcb85fa4462e5cdb4f6a46a9696"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
