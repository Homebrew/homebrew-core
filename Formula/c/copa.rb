class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "886aa760e9bdff174686d3c601cfb2f53e824299796ace3eef94dae03cdf15e1"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "060791ddc07d2321fa05d42f8e63e304f8c221f4d15a7228983659ae97bed2b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "060791ddc07d2321fa05d42f8e63e304f8c221f4d15a7228983659ae97bed2b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "060791ddc07d2321fa05d42f8e63e304f8c221f4d15a7228983659ae97bed2b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a80b6a01b98ef9fdaee6b12cd169afba86feaa4a1c3b111ed660534ec9cf4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927754db957c23f31677bed21ae2e86beeeafe35574dfa56529e720d7cbbbd1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aacb7d00031baaa5fa2e28cf78bc9e5dafdd790b28a26f77dcbdcf72ccab5883"
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
                          --report=report.json 2>&1", 1)
    assert_match "Error: no patchable vulnerabilities found", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
