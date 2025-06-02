class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "5b6506cd9636080f9135da612840a2893ed9dd9ac96b84cb810f1d8661c9a163"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eada66f55acb3ea421c4c518d9b0a68124486de7510605fd7098ee6f3aae6b6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eada66f55acb3ea421c4c518d9b0a68124486de7510605fd7098ee6f3aae6b6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eada66f55acb3ea421c4c518d9b0a68124486de7510605fd7098ee6f3aae6b6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f679c6447ab6103fda5decaae6aae1898516c8be20ec114d1c4973ff70c8685b"
    sha256 cellar: :any_skip_relocation, ventura:       "f679c6447ab6103fda5decaae6aae1898516c8be20ec114d1c4973ff70c8685b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c486300d2c3d23037cb88b2394694a05e3db75bd47b9d6ec41cdf552e19fbc9f"
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
    assert_path_exists testpath/"log"
  end
end
