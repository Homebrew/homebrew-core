class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "f70ef3701ec6ab9711a529970fcdf983ab83558989eea4a3caf539c7486c9455"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca0d0272b5c65ed53f490241ff892562d908b9a95ed17ec556e7c1a3fea044c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7062a23448f5da292642d5147d638f47b4556012e1d0eb603b9aaa134066f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f7658e7f22320d90909aa04ed72837b218aaa39db6ddd0cb51a90a32203f0cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "264ac0825c3aceec11b0960ba337ce559b59a916eda130a14f9097d291da527b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b88e7a884773fa6d7b184f28e8bcf61876242bd9d2231a82db0b57d263b7d3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48d7e309ca9f82d221ca261fd2dfecda5f930736cdeb931759ccb0d5863fc159"
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

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
