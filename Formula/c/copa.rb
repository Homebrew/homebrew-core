class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f3cc0edd568fd50a45f353321f251c9b051e1f9506f150e3592572d6d734a558"
  license "MIT"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4917cf9b07ae01263def56e951ec550f8ad620ed8b8ab1e345919c0537f536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4917cf9b07ae01263def56e951ec550f8ad620ed8b8ab1e345919c0537f536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd4917cf9b07ae01263def56e951ec550f8ad620ed8b8ab1e345919c0537f536"
    sha256 cellar: :any_skip_relocation, ventura:        "323e09911483fff8034cc02d16d79e1d1d7f2f3a7f1bdd432754c58b01532385"
    sha256 cellar: :any_skip_relocation, monterey:       "323e09911483fff8034cc02d16d79e1d1d7f2f3a7f1bdd432754c58b01532385"
    sha256 cellar: :any_skip_relocation, big_sur:        "323e09911483fff8034cc02d16d79e1d1d7f2f3a7f1bdd432754c58b01532385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34e7f43d3b72213055adb523ec2b49e59468f659ad3f4b969bbafbf4b7b73ec1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
  end
end
