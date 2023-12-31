class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "c67f351ddc8eaa66bba5b3474d9891e9ef8de4bcd89e8a4fd0cfb413bca8fdc4"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d92806c67c14e8d838196e84f4179b7a98621a090c5896375305354514aafb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31ec8f877e5b33279f2c1bc0e9ae3d2a5b6e2026323ab696be2af0657a110b08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bfc67903164bfda4909ebabf09d5d5875126e619e9ce9f63fc8afd380b18462"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6075aeaa4385253a3c60195b89130d2beb0ddd438481a29a49667167adbf412"
    sha256 cellar: :any_skip_relocation, ventura:        "26b0a09c0261d11b970d4eb1f0da717603e520909858b97381406ad08ae791d2"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9c2a2fb7b39cb63addd28a00f2897c46f191b10eadf86a21208b574e88244d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb706b2cb241c0bd7f302f77e8b5e729c27c1539c2929196248248958577d62"
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
