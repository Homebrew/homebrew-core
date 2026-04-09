class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "9570251c26b5936a7ab241cb2b99d8947290afa5eecab2c23df253979cc56f47"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af75c770651f60c5569d3e85249caba4261e1653c9bac7fa76c29ba840e2771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb486ca9a9824d42bf556fd12bf85084eb2104bd689b1af4b40dc1d2fe3cdb6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd6127b662ec7454c1d2fb4ef6da3070c4c5846ff1ff74d2eed8af91aae9c282"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1c1350cb11f533791c3fc4602180f209863a683c982f3399d87a9d8f5ecae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8618a1b9a4372fcbd1ad538fd4d0c68699038f185e368ea2e74412bba32f000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e2bd23b7cd2fa7f1d71a49451742138978a57d0ae7dc9135d16afdf31b3e16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    spawn bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
