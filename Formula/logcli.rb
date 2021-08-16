class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.3.0.tar.gz"
  sha256 "c71174a2fbb7b6183cb84fc3a5e328cb4276a495c7c0be8ec53c377ec0363489"
  license "AGPL-3.0-only"

  livecheck do
    formula "loki"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "944d78c7783b6ff9c93719b58fcf50b432a607b5714088c9ecf6753ef9896a1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "010b87f09d3cdd55d1ef66fad6ef9176f56a41767fcad6ecb9ee350a37b76daf"
    sha256 cellar: :any_skip_relocation, catalina:      "f23faf5499ddc695de6e60b669e86836e33b19c6395d6be6e60e705a627d054c"
    sha256 cellar: :any_skip_relocation, mojave:        "003939be01f7a8293bd50df88e59bf20a280815afd7341562dcf139877d15e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2de3bf7b13cbe31c833e6b610c86f6c201092a117d3dc2b5858866b6243a36f"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
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

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
