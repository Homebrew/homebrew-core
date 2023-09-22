class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "98f89c6fb1776d219476b1053adf0c21cd8fef9f1bb1efda654986dd11c8bafa"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adf6a4e92839b796151215a8c39afcf996b4172e80590f7373b84bc900f86399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e60e48b5021444b886d81f74fca2ca3c4f845910583664ae7aef6e6f7c22823e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d579ac24a7c5687ebb8db3d118f28e5aa80a0a2a0d49bf99e04ace90d9bad5b"
    sha256 cellar: :any_skip_relocation, ventura:        "5ce7bbf948365d028c6a3348ab31d018b5bd1612af3c399f6c6c7f7881486005"
    sha256 cellar: :any_skip_relocation, monterey:       "2b9ca89c166765104462fd312f70a86d7711bbb420b0f2b39edd62c7a5590f90"
    sha256 cellar: :any_skip_relocation, big_sur:        "786e935b0e6fab0e759f5e60bc85b8597fca992a7418a36c289e4a86e2b786f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bff1dd9be667654a40ec769807ecf38b7cc3550f24c34ad77d6ac6b315115589"
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
