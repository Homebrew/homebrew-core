class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "6764232edb1a3b9f3adfff0887f4bb496380bffaf89fc87ecf03d8e6c852e148"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec81c3c97b0e14f51be51ce56530ee65e9ef54b3a8baf7d3a134c8df2f3bc663"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad21b4e8f55edc1a7dab5e900eea07ef6bbb06c886c2f3505c2d61fe4aeda20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e8f417c785d0a23985a62ccf6f9e3ddfeffca1133113582663cd3c6f928be3b"
    sha256 cellar: :any_skip_relocation, ventura:        "f8340432a6574ee707406a0794ec68f8ef790a4fb2adf4fb4f81e990507688f7"
    sha256 cellar: :any_skip_relocation, monterey:       "b67c572949d10832f59a48dddba3536418599e942ee8a0cc7077dfb60734addf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b89a30ca5e074d299046471b547b97a6300b8a95fb88ed879764eb3147be829a"
    sha256 cellar: :any_skip_relocation, catalina:       "1eb670aae67f7bd9e256fb22e3198245ffe248978a9d0b2c4eadc2b850805174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c360fc35cbc8c0d205446b72f0b53c1d2f3eb9c623acf98bdd8e7a07da277306"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    fork do
      exec bin/"livekit-server", "--keys", "test: key", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
