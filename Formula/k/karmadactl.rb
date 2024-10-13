class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "905cc46e0b18c849c24ad5c9bcdc549da5712bc9edd7ed0c9bc0e40cfc22b5a3"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74fc27efebe5c093ad528de9e4d05ea3f001aaaa3a00fd48a8ba2c080a1ea3f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9135d3329c938ad9eba2d14b497e34def19dae243439fcd321d828ce98f855"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04bc426e9eb7151ec43f0755135b1bf5a7780c11147822b2c4546523a91b1774"
    sha256 cellar: :any_skip_relocation, sonoma:        "340beaa40d5151c786e4d9a9b73bee3c3782737f5d9de4ddc4c25d732cd6efed"
    sha256 cellar: :any_skip_relocation, ventura:       "aa32b7399d604e93cf31359bc72cc8b00b3ff3f321e6f87846d3dcf98d042cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731778b35d030cfd8c306e9666b1a2dbd287cae58d472ba686d9daf92a3d83b6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
