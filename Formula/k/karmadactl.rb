class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "efd59f546d602971b77e7f135b40566e0ce4190788483305ab94f55e5c81daa3"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "172e0334e3277be738372b219f9e87fdd7692a2f6cdd6d28f92604848bafe83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c75ab1826f5ad0e1e2f59cb4b68a2eda979e590d97549f730c2abd7173fb9613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c09d60a1f685cd74e77c0de3e1a3ca646553a2c02bddccb946318fccb9a5db24"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1794d2c91a674e93b3867fb361f6c0fbb1d7875764f7a8844499a6db0b982e8"
    sha256 cellar: :any_skip_relocation, ventura:        "0c8456249c0f60888953b07b32bedebbc0d8864655426995a2868d27fbf36fa7"
    sha256 cellar: :any_skip_relocation, monterey:       "734079f5fbe9cd747804ddf88f9b508493a3476b86bf428b5aee99f00026d9c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aae9aa5ea3d21cf6a40c928f1c7d6da646bf60a966a77a7ecd23c50ed31e620f"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/karmadactl"

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
