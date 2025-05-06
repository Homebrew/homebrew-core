class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "bde3ec9e82ea88386dafbda2a26fec85a4ac7f2bcd75bda298beb9e2eb81f01d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3976757fcebb042cc22f8ee3c9204aed53b7980840768d022b3da4840691041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3976757fcebb042cc22f8ee3c9204aed53b7980840768d022b3da4840691041"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3976757fcebb042cc22f8ee3c9204aed53b7980840768d022b3da4840691041"
    sha256 cellar: :any_skip_relocation, sonoma:        "f83052e32158f7684730217b10da5dc328e4967a6b7ac4b43abd46d15582d511"
    sha256 cellar: :any_skip_relocation, ventura:       "f83052e32158f7684730217b10da5dc328e4967a6b7ac4b43abd46d15582d511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b049f6bdd69e0bbc9c1e0270669c767e31e89c52c9e0f26dae39938f03503e0"
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
