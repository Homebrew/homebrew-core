class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://project-copacetic.github.io/copacetic/"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "2f1a34928192afa3c81cfd8e069e61443e4a1041f8c5cd58c74f9425fea8df4f"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30dee3cd36f3833d836fee55efb1e7d501f764c60d92fe630af59b07834a4817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30dee3cd36f3833d836fee55efb1e7d501f764c60d92fe630af59b07834a4817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30dee3cd36f3833d836fee55efb1e7d501f764c60d92fe630af59b07834a4817"
    sha256 cellar: :any_skip_relocation, sonoma:        "66cf669fed416c58c45a7de831ba7d9b5fd46d4824e8d9c0a714f73614057ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adfb1e400fafd193842b1f8b33acd0cf19560b65f918a1e5c29af6f12efdde94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89ba4a0ab08e28dc815a3d5112b8633d9d3aa4b9ae35566bd8c505ebe03b278e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/project-copacetic/copacetic/pkg/version.GitVersion=#{version}
      -X github.com/project-copacetic/copacetic/pkg/version.GitCommit=#{tap.user}
      -X github.com/project-copacetic/copacetic/pkg/version.BuildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"copa", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"report.json").write <<~JSON
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    JSON
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1")
    assert_match "Image is already up-to-date. No patch was applied.", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
