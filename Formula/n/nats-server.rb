class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.21.tar.gz"
  sha256 "e547ef512b59bd124e6851ee288584f6fd08cee3654f8c4a570abe11bc8d70a1"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0709a071d974c82336d02018069cf16c202778ece0a2a2e290f645a39cb22832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0709a071d974c82336d02018069cf16c202778ece0a2a2e290f645a39cb22832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0709a071d974c82336d02018069cf16c202778ece0a2a2e290f645a39cb22832"
    sha256 cellar: :any_skip_relocation, ventura:        "0fe1f80a98daa46e5f1a4485517e30908a770ded0fff2554e1c7662d33b090d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe1f80a98daa46e5f1a4485517e30908a770ded0fff2554e1c7662d33b090d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe1f80a98daa46e5f1a4485517e30908a770ded0fff2554e1c7662d33b090d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27b43f1617370b8ae8c225f4f517378af82d4b634aaea04fa8c87766197d2771"
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
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end
