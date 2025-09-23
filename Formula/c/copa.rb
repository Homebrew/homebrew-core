class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "b88a1618a3586d2e61dfbd2049755671a41b43e30faa3c1210ed378fd9ee3fc9"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76e9d153fcaff37c16fc7f75bdc6d0fc8d3bbd85b8a17153ffcaddfd785d09ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67ee88a24c243b564d634123f90c013c7fb8db0ecb1bee2bb58f82c5f1d0694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f67ee88a24c243b564d634123f90c013c7fb8db0ecb1bee2bb58f82c5f1d0694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f67ee88a24c243b564d634123f90c013c7fb8db0ecb1bee2bb58f82c5f1d0694"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3f2d05df0abdde1b2d9b7eb8b616f03da6ba294fc16c1536bd771f142548ac"
    sha256 cellar: :any_skip_relocation, ventura:       "7d3f2d05df0abdde1b2d9b7eb8b616f03da6ba294fc16c1536bd771f142548ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf9c73081753d183c29c5b065a4d362f39420c12e644fa6b0a421b796404f8c"
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
    assert_match "Project Copacetic: container patching tool", shell_output("#{bin}/copa help")
    (testpath/"report.json").write <<~JSON
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    JSON
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no scanning results for os-pkgs found", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
