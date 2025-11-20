class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.12.4.tar.gz"
  sha256 "150e5ed039fcd013be73b6996fe1b8bcaa66ed12e6599dec83f06894e12299b2"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17a37f4ead855899091406c5f7f35eeb191dd770cd4a4ceb42b2f756fe1fdc3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05e71fa4a6ed16fa0b0bf71e1ac17605a43247afb74faaf78a200c18fb5efb15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a0c0fe87509b4dc923cc6cbe0403fad2bce515de2b2581e9cf511e6940fe83"
    sha256 cellar: :any_skip_relocation, sonoma:        "534306fd4f18fccda5630e703d6a321f311997e1d89531cb196890ad31e3fd63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c237dee18f86336a6c659a2f82ef2c3e2732c3fffc01bb499e29eefcf41159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22612df8752d476622a90e2115f595138eb6731b227b062b8660120216e884e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
