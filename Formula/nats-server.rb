class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.2.tar.gz"
  sha256 "e9d38108d2f1a57d7126a9a65dd2aedc5a7ca8fc3b1560d33b288ed1e1f43427"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "847e928f6e921fdd189962f9382455256fc5a32c8ad6569be910cec137923a06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3e9d1ef25c9f9b14cb94e44b3eac97bab551aaee01b571f9e5227906948ec0a"
    sha256 cellar: :any_skip_relocation, monterey:       "4d05c129e6bec9ee4410a98710817bcf53098f1ee77c0f4428ece4bcc100c57c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d82bfcfdecf81d0b9f4b757f7e875553c7d899f7ae905ca5fa721cb65b9bf10f"
    sha256 cellar: :any_skip_relocation, catalina:       "92b01338ca01f75eba16b5e4705d737544dc36a59c1a3d638685a83515966a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a72137b04cd0196a4f83304dd3389d82d7e08ff69a6ba74d64e0aefaf33ad69"
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
