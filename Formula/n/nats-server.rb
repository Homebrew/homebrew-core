class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "01eab5565268c280b322c8601932edaf41f3a2c688f119ecad90ffa47d55f015"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac48c6a63b675c6396e06f6a1dbc36bb85716ab457c9dc49c2e4e37665df262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac48c6a63b675c6396e06f6a1dbc36bb85716ab457c9dc49c2e4e37665df262"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fac48c6a63b675c6396e06f6a1dbc36bb85716ab457c9dc49c2e4e37665df262"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c39f92dd2f795b7dbf126b1b2e92738900631f4cd3aa079333aa5f2e993e295"
    sha256 cellar: :any_skip_relocation, ventura:       "8c39f92dd2f795b7dbf126b1b2e92738900631f4cd3aa079333aa5f2e993e295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5addfab003abb2cf045134a2e0462bf3be628f0f45109de787ec6d2d659b153c"
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
