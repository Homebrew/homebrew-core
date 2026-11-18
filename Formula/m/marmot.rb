class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "82f30dd2cde2b5a7a5fc43e72d21a3c620dc76decf9da54709de823beaee6a9d"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc81e96d6913eb5f2ec06cba657a9e305a4197a7a54314775b1d3f7c8e2a0db2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc81e96d6913eb5f2ec06cba657a9e305a4197a7a54314775b1d3f7c8e2a0db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc81e96d6913eb5f2ec06cba657a9e305a4197a7a54314775b1d3f7c8e2a0db2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6fd577735987c573d073061d2b5fe4ec27730bc472fa37cad118741d2294720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "eac99cc2e450e32ff24c707d900f8cb250782460f532f3bda4a56f80b512e1ed"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/marmotdata/marmot/internal/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
