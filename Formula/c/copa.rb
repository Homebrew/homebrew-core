class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ce66b7befe2e69352cb1dff4ca9e99ee8ecc181f1870e6edc23c31975cc575bc"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dac392c4aa445ae31d661f44a4052c382ccb362ddd0bbc669241f5db0e9c5a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "221d0b9bd5a23212f5ce6b014563d12ea822ab43302434ae24f8dad5940ecc30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbea3eb028053c4b73b5a57e4279734ec549953760c55184344fd1e8683ad450"
    sha256 cellar: :any_skip_relocation, sonoma:         "948f8869d1f622f8268bc0b7cb12a6932d4d62b59aa36758b2b1422a34dbdb10"
    sha256 cellar: :any_skip_relocation, ventura:        "7b81a20545d3089a371099021e70bf2d2d970f7f008b9f73f688d0d4d812717c"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e8b444e13902ee4282d0f25a917ef93e3d649b4f89e1fa19ef1667082d4360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265014d37f8eeabb8c85567426c4d4f1fb95ebccc8bb8b9eb75a40fae9546548"
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
    (testpath/"report.json").write <<~EOS
      {
        "SchemaVersion": 2,
        "ArtifactName": "nginx:1.21.6",
        "ArtifactType": "container_image"
      }
    EOS
    output = shell_output("#{bin}/copa patch --image=mcr.microsoft.com/oss/nginx/nginx:1.21.6  \
                          --report=report.json 2>&1", 1)
    assert_match "Error: no scanning results for os-pkgs found", output

    assert_match version.to_s, shell_output("#{bin}/copa --version")
  end
end
