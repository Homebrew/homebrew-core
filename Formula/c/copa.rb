class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "47cf4c4e583d35523ef1e146e9a640bce5ffbb99bcedbf63e07c11eab60b4a8f"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17368549b019ccac22fe06200bee34d534c8fe4a0c0f56247a14710e0a9ce6dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17368549b019ccac22fe06200bee34d534c8fe4a0c0f56247a14710e0a9ce6dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17368549b019ccac22fe06200bee34d534c8fe4a0c0f56247a14710e0a9ce6dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9481b1416a70cf0a6cca5584c0f52ff4f402231366e138eac6dd75a0ec1564fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b5dfc027c1546bdb54de1b1fe2409df969a23618aefd1aabacd831fa88a60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83b867b11564f03ff5e48c6dd5088a9a59a573bf8c2726fd57dde11fdd322b33"
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
