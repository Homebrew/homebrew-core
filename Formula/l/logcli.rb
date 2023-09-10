class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.0.tar.gz"
  sha256 "47b678408239019d85ad0d9ace5bd12304d2d315dec308a9b665ab34feef813a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a05d1e0308dbbfab3035dafcdb6575c6122730dd4fb9637bad8c36d77923df86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a760c07fcbaa44594b33a86c31aa94fccfbf4021f8020af1948338a4bd19572d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb4f5398d223874e5399d92413f4cd657b246902cab8bc56d265a5d458c85e73"
    sha256 cellar: :any_skip_relocation, ventura:        "3e5e9af5d02f7a927d475f9bcf311ba9eac7172a42e88070f40e344e99e98005"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac06f0f4c3a833e12a7a370a84c9137e597ca00b155e9c6326a9ffdeaa29caf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0fb66799f7657ee84299b5bfb28c102802c823962b9debf4c33f2234ebd61f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467afec5788c5eac329af1d17431f6f11e50270d77fe8cc3f2d1d1207b5c9d23"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    ldflags = %W[
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
