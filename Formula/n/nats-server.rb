class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.3.tar.gz"
  sha256 "34611454a6c38aed0bb26711b2d89620cb4c298cca93485539c7dc1e84558054"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1237be07b11ee612fb164d095b4784c51d3deb4a71ee51d019f539d74e6d7a41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1237be07b11ee612fb164d095b4784c51d3deb4a71ee51d019f539d74e6d7a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1237be07b11ee612fb164d095b4784c51d3deb4a71ee51d019f539d74e6d7a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7ec243cd6f2a1c9a68316e4777ea9c9fa50afe79732e896d9302ce366c2ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f93b26cd005a8ed98ee7a2224453651fce12642ca6178a71059b7a26c83720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f19997100f7ac0676e908164cf8e807396d7945ae590964778c3d80632d7bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
