class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "d8f11b48b2c95d3f3748c793c84f47d5ea6d577e59d2073a260281613605167b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c82a38db1a932fc1f9b2d03c89346b2f3ba4548aa550e88cd830c7a56de37d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c82a38db1a932fc1f9b2d03c89346b2f3ba4548aa550e88cd830c7a56de37d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c82a38db1a932fc1f9b2d03c89346b2f3ba4548aa550e88cd830c7a56de37d"
    sha256 cellar: :any_skip_relocation, sonoma:        "04b06e91d9f1aea116ae1440b1fd6268db982d4cd3f06709afcae61ae6e6d071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df365a3bdc9bfa9ef0a2efad0422d655d1641d51011894150de0cf1920183423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "251549842d3e838cdcac151ee0f33a4442ad8f996161988ffc5c8f608aea1f29"
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
