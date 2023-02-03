class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.3.tar.gz"
  sha256 "07b7030576abf4ef63febf4dcddf95ff935aab6d9ab4fc0404322794d94bf3ee"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2c0185ab8b68cba01bd10af6a0822abe9393be054b5cbee87cb234ce4c31b8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4490dd973061dacdb324f4f804cac62bba604b2ffe4b98d100853749ae1a62e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bb99eb30077bdd7e744232afbab8c8ceaaf6b05f1afd41f72f56939a7cb990"
    sha256 cellar: :any_skip_relocation, ventura:        "055a43f5c4c4f82432be88beade6f1457c2ad0db9c79870629f03a5cf165c086"
    sha256 cellar: :any_skip_relocation, monterey:       "4acd94762a4e9eb7a1d9bde459e52f82adeee6809faad5139095233c663a92ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5564f663c6c91ac289fcac38167c3f51ac9191c39310e4c1abc4920ed4b7e45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e412c9cb2ed612d31330ce6199953e0e408ae27f61c720602102d5723ce79efd"
  end

  # https://github.com/grafana/loki/issues/8399
  depends_on "go@1.19" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/logcli"
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
