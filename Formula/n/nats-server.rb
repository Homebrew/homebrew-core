class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.8.tar.gz"
  sha256 "d76f8566d64573e467fef59c1165638c765ccee165760e55cbab2b2ab0c5eeb4"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "077c614a2dd0b11e6d065fef8ceb544448b2c20be12243fbcf989ce40943d98e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077c614a2dd0b11e6d065fef8ceb544448b2c20be12243fbcf989ce40943d98e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "077c614a2dd0b11e6d065fef8ceb544448b2c20be12243fbcf989ce40943d98e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40ac4ed29b26199a2a0f8ed8c3d7855c15d60168b5f03cdd4d6b7f23b8037fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d25085a4ca7a94f5831428fb33374bfc3db6cff4d1038a3bccaac5b8cdc8ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40d585f6bf0ed0fb6976fde02ba57b4269775160acee077830a27cfe7936762"
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
