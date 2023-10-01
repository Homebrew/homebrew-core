class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.1.tar.gz"
  sha256 "60c30c9d6ac2e8f7eab6917684c9c843a638cd3d3f31755f9d0ec8c6839a8196"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2051f59d711f0e0e8601c387c0d9f9a4e2e7677638614cf661b851d5b6dbdf0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "487ed23b9957293c1a03aa303122a8bc20f40b253ecd290a7b182164262f8e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0d894ff61a7ff3b1ab22d5c37f21a2e49d221d8341c71d2ab45d90f89b23e07"
    sha256 cellar: :any_skip_relocation, ventura:        "a79bbc7ef11493b0c28e947bf2345291738f28e58a4e201769c8a2ca26446e69"
    sha256 cellar: :any_skip_relocation, monterey:       "e2b8e4e66619ce88af1607fec243e83f53903a524d6071e257397b67a83fd90b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b72b12947f01d898168119c2e77c02bf25774e70e5fc215a9a8ae39783f39391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "888413d60b52dee3ebb45ff29fe7366c2e44dda51737ca0581c632f0f5896c90"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=homebrew
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
