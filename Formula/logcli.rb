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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622a7d6a79aee45f24da250165a441375b780b3ca6c526a143dec912a30443a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49e33500d70ae8bfa0f3e0fc5f80f7bba0cae454ca0e546bf4d21b58b5cca13a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "714685508965229552bc42fe1f065256027738f82a3ef30cd3b488dc6c4e8021"
    sha256 cellar: :any_skip_relocation, ventura:        "e26b7b6c00974d8e402c81421aaabc9986d063e80b92d7fce219b1c369ec96ba"
    sha256 cellar: :any_skip_relocation, monterey:       "7b1f1c6a3f58679607e723371377332b18f12a042dcdcdfcb32ab0f1c0a065f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc29c7028748e0ebd6d66b68c0b8743dab31c5cd8c1ce8cf3ece40c8ec516113"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd53f85c3fbc4da7dd2c7645bd40948feac8fc735a342f6b55259c314cacd11"
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
