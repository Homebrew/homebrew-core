class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://project-copacetic.github.io/copacetic/"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "035d87fb7589234102d17c354ab35e1f2c28f1f80df875bc9438b92a19a86804"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92e017c1f99ef926c939150ca09c2faa2a02c377cf9535d1b45ebbc199f5ca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92e017c1f99ef926c939150ca09c2faa2a02c377cf9535d1b45ebbc199f5ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92e017c1f99ef926c939150ca09c2faa2a02c377cf9535d1b45ebbc199f5ca9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c1b1c08db56ab1b75a79e35136075bf6984c284564862f96f980bd8df47d6e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca2ce4ee5893e7dd3cb3cb9554422ff97be5a747eca67d88ce3cbe911d7894b"
    sha256 cellar: :any,                 x86_64_linux:  "6ddc9a3602ed9074882746a41ffe31ccfc211018575236f9cdb4bc416b0221c6"
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
