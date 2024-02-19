class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "d8d663b3fedbf529a53e9fbf11ddfb899ddaaf253b3b827700ae697c21688b38"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf4d79a4fa0feb4de0fb22e37871fb27874a1cf7a90e089ac63ceb10d378b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d02980e014449ff7a382c39acac5c72ee1c9ec47010346146112d6f8ad854ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fddf4aac8f4e8fbf6178fd0324f05e85d4d6503baad20f5764451634c808168"
    sha256 cellar: :any_skip_relocation, sonoma:         "00e8b0703831b312626cbf924d6c0305a720a351fe42df00ff02653efa40dd54"
    sha256 cellar: :any_skip_relocation, ventura:        "df674fcced767ef7ecd0547b028e28e62322f83aa980ff350c6fcfe5a0f12717"
    sha256 cellar: :any_skip_relocation, monterey:       "4258e4f01b692d828f4009641479e859c9e5037a7315de16915ccde6c9c4c13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281c0f630596fb15434443f86d4717cde3b37668436688695261c8648cb6f01f"
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
