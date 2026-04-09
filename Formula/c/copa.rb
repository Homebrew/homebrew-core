class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "94fcb4cdaa40f42c20b39685e7436f06ab78f18e7379b69601b117f4ed5cc780"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c811bc53233675b7a9e649f8f5fbf8541a36cd0a85c3e72563c060977f183751"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c811bc53233675b7a9e649f8f5fbf8541a36cd0a85c3e72563c060977f183751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c811bc53233675b7a9e649f8f5fbf8541a36cd0a85c3e72563c060977f183751"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd32d26f28ba7efa9ba4dc96bcb1d28ec773893fbcd8f86485624393562d63cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1809a7a1751ad605a94a0339feb969abbd2a54cd332171874981c6f383f740e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc4f21c153d18b97d910b5dc3c919667024d80024b0710137cf03c36e0ba956"
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
