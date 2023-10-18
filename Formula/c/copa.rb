class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  # LICENSE change from MIT to Apache-2.0 in v0.5+
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "1aad8715071852f4a3d3950af1ab7db49eef423c5db1f739238415051310ff72"
  license "MIT"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "942ba3fcc05a4fb24b548fe747fcd91e85ca5c11707da94420c4bedbc96ac069"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3667231786301df5bdca39a6ac904ca2ec79229662ad2e6c71cdb1324a5ef96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95ccee0202f096779a4f75197a6d9c526b3c15f18e6798abf40a2080a5e6ecb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c237ea9ad722f6b5aa0359b616722f9b58639aa94b23652b7133ddef3e1b3e8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d6ef970f98034739def61640b067c7ae493044352802ccdc9112ef242bd4377"
    sha256 cellar: :any_skip_relocation, ventura:        "14f651023f64a2eba0e98806771cb6cd5533f9ec0ac98a20dd92f3394b22d82d"
    sha256 cellar: :any_skip_relocation, monterey:       "206e617d60efec58055088a3ddcd7e40310cf0ede918a4a7659595e5dd0435e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8f3d933e3c9ef810f8070867794f6d119943e5f2633d58afa38080991cae07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965aedfebd7cfb92c22a4229427ae30d1f2f5ef1cab0d88d3caddd106e1f27a3"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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
