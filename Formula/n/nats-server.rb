class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "6cb710a47f80a56ebc4135f973d8d78cc7c06a88309355069e75d69bcb7ee9be"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a503bb0342109600e803c52033d6899019cff023d0b6010da5758b1d31d804c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a503bb0342109600e803c52033d6899019cff023d0b6010da5758b1d31d804c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a503bb0342109600e803c52033d6899019cff023d0b6010da5758b1d31d804c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e185c1a328ce58683b6d8d2a1aaedb2425189cf8581dd043a8c70fab89a2b10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c32bd67d005459e259b29c24942890e54a868ea99a7214a54c52373ec00f1cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a10cf28b7e365a4e818c61d534add6ca61152f26c7ec42a9360078a5c3065f"
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
