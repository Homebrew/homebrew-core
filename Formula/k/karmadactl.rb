class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.17.2.tar.gz"
  sha256 "33917b21ed768cb70e6cb3eab47c504db6e8b04d2ec564a1d4fc2776e779586b"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b48a55346fa9e7624741b429e23ee3750dcd77dbae884d9f7a622dc7fd40e3db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b638b88e290bde13c074680897e1f421002df4b2b61f67ae48df241a8e7704"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab7c80220d55b4780987b43d53a10617d8f868cbf8d8c834f762fbe9b9f567b"
    sha256 cellar: :any_skip_relocation, sonoma:        "513eebfa9e0e7ea3410b4e57abab674f5c1c456d424c1c4379f27816fb6b5297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a69d649236ef5cd82e354c64a6193169415e79435a9e9ca8af9d447fd87a30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671d516b63b219d89c1adb22830ab9f6073c4900603fc00da054cb0e3f93d1b4"
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
