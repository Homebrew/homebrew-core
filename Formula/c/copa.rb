class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4441630bca610ef6ed2ef17f353b27632bab4d0a2410f99bc96f0cd3f47b52f2"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969e721d1f6b6fee2011c051609142aeb8950ebf74c02f3b51e75e48d2b98c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b9e85da0b7a435be8ea6bece39a6f8d69e0cc4665869de13a672da81be933a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d403fa235446f405793bc94b659e8b1db4f73dc7940f33032bca3fe2783235d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c473dedf7ed6d875c86756962b74a93b4f0ffe98294a368cd3941dac491f2056"
    sha256 cellar: :any_skip_relocation, ventura:       "b0d0dec095c5035c77c97115a91cc31014a665798a79dbddc0cb7c26ec0bdeef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd4e8c261fd31d0cdcbce2401183b2fc2b386feb10c520f1c10bb9f02a9adad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e41b16c68e598ddecd219bee333ad8a405dbcdd6759fcbf49ac226638ba957c"
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
