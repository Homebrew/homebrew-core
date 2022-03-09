class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "4a98e3ba5022f55341aed7c07b6c61bd93be82de76ef03758825ca9d53310e6f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76d1d35b299d583190e16ea920bfc8224e76c498b5052df49dfdfae80a7d56cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe426ffd6e07f74c9707b2349051ad999c3d0330dc21876c036926a5c1343731"
    sha256 cellar: :any_skip_relocation, monterey:       "e51f5fb020a1331a6aba1e53c27a12a422e8eb08ef5c95342e0193d417370302"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f3aa5013e23aa757c2e1399edb6d275d564512f6ffa9d68b3c00265d45261a4"
    sha256 cellar: :any_skip_relocation, catalina:       "e6cb7dad82f2a08083fcd23996d946a7b700d788c62b5c476767e96ccf2f3521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76040da51be329535773992bd961fe23838ab79fea053472612f20f529977bb6"
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
