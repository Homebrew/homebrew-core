class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.5.tar.gz"
  sha256 "a3f3546fb6c32402732f8ff429bc3f67ae71b6118071590a5bd71d036fdcda8d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab4804d696f07179a1240254a8c79edcfcf352b8f9b297ba7937d57e7a16a4f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab4804d696f07179a1240254a8c79edcfcf352b8f9b297ba7937d57e7a16a4f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab4804d696f07179a1240254a8c79edcfcf352b8f9b297ba7937d57e7a16a4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5491baf3ed7f5828ac5dd482e702d8160742a22857b41eed7fc11385839993a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d70f883aaaa517b1fc5e036268b3cf57549fc9d2d0794c78f103ec409fdbc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d91d088f122d416443fa57e271684245f665d8df3a7c87664ff4775ca122478"
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
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end
