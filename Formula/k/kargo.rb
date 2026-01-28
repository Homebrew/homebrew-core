class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "6fa2306a171c1023d426150ba2405d3ccdd87d61cbea67fe9b57d49113a792dd"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "277d136cdb7c45028f4490674e2371934f4ccda296f42a83eb0aee09556ea621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f90d6f8f2c7b7f074e0048f902c3103900d9990102a3ed34e0f93e347b5cd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c9e2efa8f5496da8d1e34fb7f56430c9d52b930353921e9a41a555da99004b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ad70f132cf7499526c40b4d8d081f30e613421f04b91791b9ef65971c541fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d152c44892b1bdce7dd781766126569025300ac2009b745976d5c4ce87fb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23d93a3cbe6ffa60bb0983b2bd305adefa9663f1fc1237303f2a15e01063e223"
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
