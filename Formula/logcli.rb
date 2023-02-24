class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.4.tar.gz"
  sha256 "b5521c0d12699f59ddf48ff7eaacddaa56abe90da4579f35c18f0752fc8e95c0"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a3d7762f361b3f892cc7ee669e527141bab4348a4b0829f662e9f478e9cd3a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52592b34272ab91622b4b70b37ce74872de40ad548423fb9ff25b793e4de1541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f0ea0295052e51d2ee4e9b01e6921ad9d51dcbf98fd4da6994a85ef37cfef2"
    sha256 cellar: :any_skip_relocation, ventura:        "a44045d519b1154c1343921592c806a1bd72cce7dcedeaf5e1eac60c46e4cc93"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3789712ede063d970bd1cf6a839ff82474838f621a72024da98721fd51fe9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d6010356232f1e79b3d779a3eef759a88f28fc53e3ded875f76bb70ecf301c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d601a71fbb23f0ceb11d1b5d5b8ef415c4fd695cec28bc53694a0965f82f761"
  end

  # TODO: Try `go@1.20` or newer on the next release
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
