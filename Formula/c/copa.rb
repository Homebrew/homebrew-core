class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "aea5f31e67cdc8acceca3378992ca31afa16cba346f3eedeeacdf58e32457006"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95c2895d2e550c7001976021b4c21d0edbb9f980920bf866937cc8dee77b2ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ce1375c8207984464132251a3958b6afa6478d1c972e641c350324aa3ed61fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1de37313fc5cec8dbb3a61a8efb7db1138eb8c68a198107d80de75c51f59b68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "60d381978bc4625af4789920d22f657b53683e28f15fe3fb2839cad6b21467cf"
    sha256 cellar: :any_skip_relocation, ventura:       "931fbbe17ceb8d977d89edd91e467db9f6d98c39d8ff0b88b78129168c024083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16fffdbf34046746a49f6ed54cec4354565da846edc961e7937c13d7d2004618"
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
