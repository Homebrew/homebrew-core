class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "91a93d38cdb16af28d2e91b52fc2f65dceff6309261c504ad81028a3688c1736"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdc1144720be2b4b3c8aa0f01600343f8d4bc1b9293ea34533b5bfbb41d16855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cebcadca6e06c9421521b652823dcc96793ee62fcbbc5e0f8b2761fd7f5f92b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34dcaa0ee17190786196baad806072205468f5b5491ae3c0456eb8de17ea3edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5ae1e5862a98e8188dd667815dbe70730e398e0d7b51f47240192ef91c54a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec1c08ca3aab78ee5913faf4558ab0ca3798ec46402575ca53eda46dd795db0"
    sha256 cellar: :any,                 x86_64_linux:  "91e64a7f0e2b8cc5b29c37ad757168593340d96a4eefff9a881b0df660129deb"
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
