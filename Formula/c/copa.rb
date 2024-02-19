class Copa < Formula
  desc "Tool to directly patch container images given the vulnerability scanning results"
  homepage "https://github.com/project-copacetic/copacetic"
  url "https://github.com/project-copacetic/copacetic/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "45157053813e33b0869e099bd9db6863faa93cf84c7ab05011f6d0c5e6ef4bf6"
  license "Apache-2.0"
  head "https://github.com/project-copacetic/copacetic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57cfc8c1c218b733ca328266f7400e48cf0727d12ffc2dd55560901c08b3e816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ac89aebdae377f165a146425c416eba9e5a0ec218ba3d9f2f0e319aa5a378bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c84b630093034c4a84273090285b7e53adc019f37e371b780f619241941c269"
    sha256 cellar: :any_skip_relocation, sonoma:         "01ff0338ac0be69cb19a37ea6ee26c00c9406e48882b214844469ec42b213a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "76e75131fb13a4d0b91b5b05a6b58f5f427e363b4eee6e93734bab383d737554"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7f45c5d5720aba83f7598f3801353814831837e80b7567b5c84628fc8efd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a447df97697d5bf4ae1c4e71ec44da03b3bbb434efec5484ca836dd58b70ad"
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
