class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "77a1900837a1632210f9710b669b9653e3356441e3c17722d96e8b8e17d77d9c"
  license "MIT"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f4d9c47f194b0283020ad4ef786377bac60a6d367506aba9683bb8c804ac5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f4d9c47f194b0283020ad4ef786377bac60a6d367506aba9683bb8c804ac5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82f4d9c47f194b0283020ad4ef786377bac60a6d367506aba9683bb8c804ac5a"
    sha256 cellar: :any_skip_relocation, ventura:        "7bf8df6c14fb1a89d2c330048a493478818b3c0762e3de50cd68f3a870f039fd"
    sha256 cellar: :any_skip_relocation, monterey:       "7bf8df6c14fb1a89d2c330048a493478818b3c0762e3de50cd68f3a870f039fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bf8df6c14fb1a89d2c330048a493478818b3c0762e3de50cd68f3a870f039fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "622dcbcdd1471ae4c99ccac3e909e0e7b897423d7cabbd8ccafb02b41e2a944f"
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
