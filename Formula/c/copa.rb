class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "6d4d23b02ccf8d75e95109c37ad1e8901d351ea8294acdd6f5b2d9dc4d02f75c"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d155a50fd86ddef2a7d9bea03a021379efab9d03144669120e37a18e8128e61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34d938975c4dccd925e009eb86f8b35cf73338339942fbd0263dbf3d3cae914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e775f8714b46c768bb65de94a912b31a9259451354cb75ba8f82bcd1cadac41"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b947b14b1abad15f23de3dfcb7830c5b0e1a5fb2e51cc55a53f888d0fb81e62"
    sha256 cellar: :any_skip_relocation, ventura:        "717bb9a37be8f3728a78ea39ad9c739d16e14469f04083e231514bf80cd91733"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd23b54eac3dd955c93527e5b55bc5bdc49a8f415121e929bf0b61a370cd454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04d4086543eaebb425470cb3c5a14ba2119049858b6ea7b9ba3198029bff3bf"
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
