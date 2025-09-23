class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.9.tar.gz"
  sha256 "e9876c533fbdbd6b5a28a22569f58cf17e00eeab2a99c522a9165d2a3e8ee731"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02cdbe6dd7bca3965977ff5ca945a35d9e68305602da40be3f7235fde78d39a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02cdbe6dd7bca3965977ff5ca945a35d9e68305602da40be3f7235fde78d39a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02cdbe6dd7bca3965977ff5ca945a35d9e68305602da40be3f7235fde78d39a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02cdbe6dd7bca3965977ff5ca945a35d9e68305602da40be3f7235fde78d39a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c1c0efd9b5a5457ca7aeb8bbe1fd6d0b4ff04920401fc8a61ecf8696678408"
    sha256 cellar: :any_skip_relocation, ventura:       "31c1c0efd9b5a5457ca7aeb8bbe1fd6d0b4ff04920401fc8a61ecf8696678408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db1f5b25a13e4f65a3d768832129a600aa372084eab5398bec4353b431365d90"
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
