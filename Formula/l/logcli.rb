class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.4.tar.gz"
  sha256 "d594cb86866e2edeeeb6b962c4da3d1052ad9f586b666947eb381a9402338802"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33f86bc861262e3670115f9fd68f4c9e5bb489a8b1f5f846d04578cf1a59eef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c02d4256f2d6c79bf62c827c2db2de2f766b25a9f59194f500aa934ade31f764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9761e403d69b4db947d30f96eb05a01c6b958338fecdfa041c6d37260e8cdc7e"
    sha256 cellar: :any_skip_relocation, ventura:        "d7eb39012d297e5ee3f5b9df1f19ed0985ce2f945a30bb5fc703f2440db22808"
    sha256 cellar: :any_skip_relocation, monterey:       "8a755dc3eef8ab8980f6939ba8ce5941bc99c36fa2077b5aefa1f76566ecb5b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d214b86f0cf8bafb972a648424404ceb98289d1939e00d33f2664a17530ee78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed3d4aafd5a84770e582f4eb022e22b5fb3d28b964dc3049b1fa57dbece4e47"
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
