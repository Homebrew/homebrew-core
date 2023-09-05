class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "d120365122fc047781c77090ab47f4ae6e675c1e69f6e03b500240deee2d60a2"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0570fb7064c3a0fabfa89941e6f492813a321038a1654223400bcaecc161fe2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17627afd44e3a2a422c2f5fee9a1540986034eecd153e5c184a9578d251c8a6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25a462d27ac59208045942c464e1fa0fa525b4e140ce4f744f6cc7cb98af692"
    sha256 cellar: :any_skip_relocation, ventura:        "5d97ab0b9f18e5516271ac310ec363231f0cb91a81e764760a94d420595d2fce"
    sha256 cellar: :any_skip_relocation, monterey:       "af818097251fc19c76114c0223deeef5b6941403158dd5cac1c0ef25398fa2a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e3bdbbf4a3974eed20620857eb92de3aab4abbd24c33ac9060a016f47cf247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d07985887b69ebddb55b91657663ca7cacc0c209462adf64672898ac0df3521"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
