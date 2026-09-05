class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://project-copacetic.github.io/copacetic/"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "603d0882485fc41d27173a52b5d9c50c92223066bc40592cec2423f6da35d142"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "756a5fab9d31d74033ffb2b46e9e99408c51ce965471c8d145bf0137a0853d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "756a5fab9d31d74033ffb2b46e9e99408c51ce965471c8d145bf0137a0853d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "756a5fab9d31d74033ffb2b46e9e99408c51ce965471c8d145bf0137a0853d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20555d1d0decaeb338a1c549d62e21931fa706f232f2d7bf761d61baa0f089fb"
    sha256 cellar: :any,                 x86_64_linux:  "83855dbc6192e585d4fce9a6c5caee8e5f728f877f007c80330b1826b4c28dda"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
