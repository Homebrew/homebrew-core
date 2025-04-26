class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "055161cd18bb5c8a46d3d0ea1963264042f0161a454c611aa916547a93d25097"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e83d85324e63fae04e8bba9053dc2b72d1fef3bfb9e188bece2cf4ba18125dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e83d85324e63fae04e8bba9053dc2b72d1fef3bfb9e188bece2cf4ba18125dac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e83d85324e63fae04e8bba9053dc2b72d1fef3bfb9e188bece2cf4ba18125dac"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8db1765bac2adba227383c77cc3398adaf8857f5a7c24765c68152f52ade00b"
    sha256 cellar: :any_skip_relocation, ventura:       "a8db1765bac2adba227383c77cc3398adaf8857f5a7c24765c68152f52ade00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba6a1d179a771e66698b13c5757b38bbbedc4e06a9e3f59eb9cd7d6f35b0b6c8"
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
