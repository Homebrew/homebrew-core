class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "7414cdacaa0c1088cd9409c9ccf0ca1a042ea38ef4504f49d8cdd7cdd430a2e2"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35e7d4fee9348fedb86e889a7ecefa3d8899cae18a26bd8e8af6b4933b12a8ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5b9df126edb4af5ac46356ad16e42b415a14b198f4fb6e7ab9abb416f281310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c4ee23edeafcce6339ba64c2da590a6996ff54a80ccc1eb2fc5614700e219f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa00acaab0ee765c8d4231e7ead47251d091290f4e15ce07e6738e37a160ce40"
    sha256 cellar: :any_skip_relocation, ventura:        "f727af4a98cec4daf0c82c1f07d0a459a182e675e2785268e51a2015a9142ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "339d01abc7a7824d23339d334fa927a6869ae33145c28b949be38fd9eced9f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8a115c3c9ee5a630bb5e4b53f540327395468eb096e46656af87d01b710ecf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
