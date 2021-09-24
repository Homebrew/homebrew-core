class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "8b578df282dabc75b93b17bc8defb0f2ffd596985e1d2b5d5f4c0695ed6163d6"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f35e212701d75748e35dd1252f7840ba49f87337067694c0134ce45dde2572ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b4afd53a631e88a952b7035ed76c084c42b2e7088526d06cc9432a294455f2a"
    sha256 cellar: :any_skip_relocation, catalina:      "79f78142a2457e399fa2d9f29800f7a8e57cc12ff5bcbbd68920dd41379c316e"
    sha256 cellar: :any_skip_relocation, mojave:        "70e96b75c6ec23de0196a9c1d95df5846fc11a09f453c028a8d8b81b81c65c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d70ed49dc85be6567d88a28e708a27378acf3d5f6ea65701287a84d2072038c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
