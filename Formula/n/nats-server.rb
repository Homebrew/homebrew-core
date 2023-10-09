class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "dbd18fa0a639bc5747b12faefb152c0edbd2a2d0c8a0b84c4b63e0af58224795"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08c64b6cd571b87b7d40286a2bb36c96f27cd9100cb003a0e856fe476633f7c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efeca807361b4d4347123b1e401702543c8c5e49bc309ea26be8242662c89364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc4db5e7b3edf4de1f65400dd895270bc954fc247035df4ef8ac942683870e8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "86e032f65a6769b63c6258f67043b5018fe468534bad066eb30c8cd27edb0c86"
    sha256 cellar: :any_skip_relocation, ventura:        "6cf439895e3cf7b302ed242263a08452398ed6f0dea64dc71d06bdd1c47be644"
    sha256 cellar: :any_skip_relocation, monterey:       "375f2c37d044dd2fd3b3b410d6c4299a94d3a966b0c20dda0b8dc1822f5169ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aab25c957819c122922d816f17ec14bbbbe7f3e0e81cc383bcf49917911381d6"
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
