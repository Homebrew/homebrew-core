class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "200fb27d97385756baa0971e630d674fe4900fb2dbefd49d3a42b3ab43eaa5dd"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8fc070321b18ab05e32e04451d41a9ac25278ac976a6930dc5ab7716b30b817"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c185e39d667425d828c499bb8b5475ab8172c3e4f390b8fa70c940dcf1b76c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "885debba3b14610a78acb1c341426ff3f4f66fabcc7bf95dfe60853f4e51ba85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7f3b26703b39fa2e545b50365b411ea6e3bf03a9705a223bc55c4cf42d3eff5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a814a3bad6c7286b6df9db71ee5700ec88f83bdb5063709bacd221b1175d708"
    sha256 cellar: :any,                 x86_64_linux:      "a84e4ecb92521e4a4b452f30b1c85a42d770fe17b6b67b3c5e1138602474c2fa"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = %W[
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
