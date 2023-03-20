class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/2.1.1.tar.gz"
  sha256 "86b7bdad7cfe373961a9721d2ecc45b5465a1e1101b7dbc96704c414b2aec1c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8588534dc5937a4d27dbb278fd44a62ebe447191e3a3a7d0e339be14985ef5b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e0e6fc85758002f30b4fe7aed3b388a4ac7c38501485c065790ee4b4a7569a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6767855dd727022b8a11dfcca655c47ce5502bdc64de6b3668b0ea98e55d97cb"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5bc5a2aed7cb9e8477f09cc12e2fa2f90f47e0a987b04b01b47ff41f94f9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "f1413f258cb0d7a09680798390c6ad05dc0202406b91fce3aca1ae0cfbb4e381"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8788037ed6c0719908924248980e40c89521f2e4929a53309c7a9a343f1f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "969c5d8efb18a2501805aeaf0a4ca12633af20771de603dc88a812169022cd5d"
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
