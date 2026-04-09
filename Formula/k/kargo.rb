class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "5c20b78f69e3b0888360224c668a77d5b22308b373593659935326d261eb25e8"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "634e2ee428f118a68fa134e02c494f55b6e5b3379beb718aefaf281191536803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9f542d3e70c3fad197ea9874677f75e9b052d3af047c10d388cb5f2652bc0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fbb6b62d9fff62e6dc568bc9bbc9d3ded703074867a925bfe9a70223f74dd51"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec82caa5f4bc007ed2ff2b828c67926ca179c87c95e341565c2866cb60b94f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4702b02897ec13b941972494829be61454324b5af8a521fe6b0344d9f70c2bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ee37705bab0a9953c522315743530957746faf4cfaa74adf0455214230becd2"
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
