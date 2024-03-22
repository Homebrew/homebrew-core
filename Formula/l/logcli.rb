class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "d3642bb140dbaf766069a587ae6b966576304dfdda3a932bf6e9a79fc8146b17"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "781d4568608789dcc72e86d71c91edaa29beea45b2293871e0d94183a2c1fadf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fb286735c40bc738a685f7fe5cac9bea1fa1d6cf218104c867bb4c9a8dc0bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed4a552faf94d8208a3aa9ff17d690680ac7f91a7332094770bd503bcfdd772"
    sha256 cellar: :any_skip_relocation, sonoma:         "5678dcc0352d1543b2426c5c16fefa054d9127990f4d8b5d62bf8c4fe4736a47"
    sha256 cellar: :any_skip_relocation, ventura:        "4095cedcc0e0e73ea8d8a4065f499fba3d96d5887249c16708efde09402c58dc"
    sha256 cellar: :any_skip_relocation, monterey:       "718e61e7394c37b76ecbda5e9b01b31356b1ace20a8bce30373f07e0413e4e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e4407e0bd180a71e8dd3664bd5e868b81c777c075df848257368c37518b677"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"
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
