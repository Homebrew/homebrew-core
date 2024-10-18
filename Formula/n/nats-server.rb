class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.22.tar.gz"
  sha256 "27bbfa502d19a698f33ecf7c91b6d85ab13b11e41cb7ced6371aa3057821bc07"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b41fe769699b30fba34e75275ea72ed972bb6743a0dd0426475dd3c2a6a3264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b41fe769699b30fba34e75275ea72ed972bb6743a0dd0426475dd3c2a6a3264"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b41fe769699b30fba34e75275ea72ed972bb6743a0dd0426475dd3c2a6a3264"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f0d21302c4afc771c6c6885c29691684169593ffd571cc3981b8afc4b94fda9"
    sha256 cellar: :any_skip_relocation, ventura:       "6f0d21302c4afc771c6c6885c29691684169593ffd571cc3981b8afc4b94fda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d929ee8db4f24bcaf13a04ea39a95639818d96e1fa7abd3ecb0faf6ada4eb36e"
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
