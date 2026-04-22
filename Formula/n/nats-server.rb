class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.7.tar.gz"
  sha256 "4a28aff2f4f98180a2bd17b5f175b96ca987204295268338e3468f6bc108e703"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90dca56f9d624c47444a7b9d433cdb699cfbe1dcc0e76c2627d0f5713e1efa55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90dca56f9d624c47444a7b9d433cdb699cfbe1dcc0e76c2627d0f5713e1efa55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90dca56f9d624c47444a7b9d433cdb699cfbe1dcc0e76c2627d0f5713e1efa55"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fab97ae65a053eea06245401619d747111a95419bb2032c259e73eb53ab37b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e48f88ae62c044e3d2341229f7a33ed86a5e52f3e3da66128c9c8523672729f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac4f87ca95c10a76e43d873266b3c1492f69bf20ccdcdb0a13060951c7e8b4cb"
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
