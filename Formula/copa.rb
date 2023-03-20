class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4261caa16e8ba25d5ead96a4fb3c033df4e4ec68305f5ce58714fe336e83f361"
  license "MIT"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e2c482e958724f6f06c9c877bc0607da0ae00a7ef434ebe15e89dcd8e956071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d138706ce28522f8f71138833d4384d882e9718d7e474424ce60a82b456554b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52c1873cb7b7bbe871f675f8c280d9066ead11c5e431274aa22f7c9d9d99b345"
    sha256 cellar: :any_skip_relocation, ventura:        "979e5ae7a125d2f9db41d53d9174e82ec3134516ffdd236b8f6fe6548ffb6bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "fb5a67189dd2a56dc2ddce2eecc7c8e6972c6fa7daeee2b82a8e5d39be56ae8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4721b8efaf2df3abef4c24bd0e61a4135185bfce49f749e84c662829f21e0cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd00e7249892f7145455e22444c28ea2e5dac98d35fa5d9bbdec735fef449022"
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
