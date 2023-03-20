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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f2c24a38d4b489fc346b365671089f0ac45581877d23d63798f1050fe09f5e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78a0115518a2b5f95a734a6a2c7ea1aba71c704eb3d8a90690b6e0df5a6e29f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "319b8f32bdc9fa3e02690b8274ac1c38c5f902edfa14b2665b031fd3f652f9e0"
    sha256 cellar: :any_skip_relocation, ventura:        "f19f0da1078c259c40b245372d11346a1057827f9adbc933f7a14e6dde61c824"
    sha256 cellar: :any_skip_relocation, monterey:       "7a7b084c24875f400696c16f952fc267b2d485b8335f00d6aa0c404634a9816e"
    sha256 cellar: :any_skip_relocation, big_sur:        "185ff24c0348b2fb8dd474325f70e878d2565786ffea011dde901d7717099ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdffa8ebea96ee1945d255816ee83aa0d96e064f487c36dfb8b241c0786bc150"
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
