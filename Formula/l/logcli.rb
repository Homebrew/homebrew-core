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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09487d11b74fe3c565641816eb83803e5cd6fbdfb38059eccd5938a8013819ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09487d11b74fe3c565641816eb83803e5cd6fbdfb38059eccd5938a8013819ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09487d11b74fe3c565641816eb83803e5cd6fbdfb38059eccd5938a8013819ff"
    sha256 cellar: :any_skip_relocation, ventura:        "a07fc4c50deaed9cd3cb98ce6069f2aac872f7909652c7684483a66b846fff63"
    sha256 cellar: :any_skip_relocation, monterey:       "a07fc4c50deaed9cd3cb98ce6069f2aac872f7909652c7684483a66b846fff63"
    sha256 cellar: :any_skip_relocation, big_sur:        "a07fc4c50deaed9cd3cb98ce6069f2aac872f7909652c7684483a66b846fff63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e91d2fbfc03c681a92e092102fe56fafbb99a42732b3b7504de0909a2f5be1"
  end

  depends_on "go" => :build
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
