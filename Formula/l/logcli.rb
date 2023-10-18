class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.2.tar.gz"
  sha256 "9c1a153ab4d57d5c109dbf55d4ea5aeab2159ccf51d3b8cc8fea19970f0a88d8"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "99537f4a139d04734f6abb4bfe7150a41207538175c1650b845ec20d8700f8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3f8ad302f76f242beb6e38183e35f63ce5b5f2510a6735434f5772d4fcb64e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca69384d652c15c22b744338a1508b8f87a1900379af962e626df1c139ad93a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d8bbba82c3288cb38a8dc0ee2882ef09b4fb98768b52b53c772c8941835f30e"
    sha256 cellar: :any_skip_relocation, ventura:        "05dbb9cad4eb050a19d6a2fdf76ed9f31e0611d18865109b4d1133f3804f4574"
    sha256 cellar: :any_skip_relocation, monterey:       "d169a2ea5fa418a0851da84f7a72a2e0cbf7508b63d7c9741f3058bf50bfb7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a0b40a1329b33d171b65a5e7b9ef40a8b9f9f9f21ee1dde16cab72d8ab2e33"
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
