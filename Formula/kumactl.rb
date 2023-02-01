class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.1.0.tar.gz"
  sha256 "c72753b8c030f6417033a7785fc369b822d7e51857935fd49954168b3361bcc9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebf50129b1ecd0d69e7b5a949a4a263cb4bf5ef5eb67a63fceb8532aa6aba58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea469c7cd60bb9e9cd452e3caf7b09964b673a8445f0e46a34a17cdcf04f9030"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d2fcbf0bc135a5991c813ef5191ae3aa6b5151077e1ef3b1d25620fbf6d31de"
    sha256 cellar: :any_skip_relocation, ventura:        "66505b8d09ff1e7be93b981a2df22e3c3b60cf70a5c6ff2b22c07becb2e64dd0"
    sha256 cellar: :any_skip_relocation, monterey:       "541e6617c47180a7e94643ae1b97c41f65ff2336f69b4b7c7752edfc4c1082dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f7a3cdc424b6621f92e3f81332623f26436895fa9d1f31ce28ffd36975488f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43206eb148965eb03fcfe856959642e9a0aa92ea328392534c2b2ca727e6bbb5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
