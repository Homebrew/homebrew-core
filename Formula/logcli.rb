class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.2.tar.gz"
  sha256 "6abc2b7aed5e41ebaa151100ca67cd5f33a85568d112b89b2c525601327d6a77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda1f933b04f3f184c1fa223d3465e24e0842161d319040d139732f742b34dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cda1f933b04f3f184c1fa223d3465e24e0842161d319040d139732f742b34dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cda1f933b04f3f184c1fa223d3465e24e0842161d319040d139732f742b34dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "92a4eea6d5648fc9680d2466abf250750c3ec61d25e336100c7fdf56c136c427"
    sha256 cellar: :any_skip_relocation, monterey:       "92a4eea6d5648fc9680d2466abf250750c3ec61d25e336100c7fdf56c136c427"
    sha256 cellar: :any_skip_relocation, big_sur:        "92a4eea6d5648fc9680d2466abf250750c3ec61d25e336100c7fdf56c136c427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d45301b5ba3ae02ee388c83b6352849067500bbafcb3ca83564c1f6194beb3"
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
