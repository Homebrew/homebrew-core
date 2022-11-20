class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.0.tar.gz"
  sha256 "fcdf692b117bd412e4b5a61811d92f18b3a02db6e3802e6abec0c4f584d31861"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30c9d6da1e5a098acc4c57d5d2b08b102b4dd6a5d65e150a86f2e66006e89f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a70ba2e57d29b261e09ac15f53489d7f0ff63e3f90d011b03cd9554d1bb99086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b555e614c1f2bba433124a04310801ed89065cb69a1ca0086316375d173b1351"
    sha256 cellar: :any_skip_relocation, ventura:        "ed56322e2e7a51ec00ffd45ca4320c1f5c1b0e9d2f4e8a6a2333707c217dec66"
    sha256 cellar: :any_skip_relocation, monterey:       "8a62eb2c98b7dc08ec0e93ddb86c5b189a7059a0ce7ea3133c37ef254a964b61"
    sha256 cellar: :any_skip_relocation, big_sur:        "78e5824b3e1e5d2bbb52a83c338768e8a8655a36bc92e0a53c7e1003fb5ab29e"
    sha256 cellar: :any_skip_relocation, catalina:       "26403cd3898a625a3dd02a561565a814a852bf4104c2649c95e5a569a9afcf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5017b5f0cfc0ce2e77ee014deef9a81389448f0a0b006846aeda935be0b00284"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build
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
