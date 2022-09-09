class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.0.tar.gz"
  sha256 "8510b50f8c8cbc8e7c82686fcf696520cab9fd0d48df0ccad3816156ad9dfdfd"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f419225db72d72f61022f11d9461e8a790932e9d461a0502d0bf6bd70e32dc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a096a54fdcdb93b4025590834c2d2611c4e876dbfa35ef2af3e9bc6742c3d95c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce0179087664139da5e6db497df7440de1d9f1fe33ce11167195246109a4715"
    sha256 cellar: :any_skip_relocation, big_sur:        "eac302cb7db52a14f09c2114227b6f2368953b58cf69a2872446d41850b7955b"
    sha256 cellar: :any_skip_relocation, catalina:       "71a206af53c96d1bf4b8576f56903208dbfc3c622b9ac56ba86c08b8aa2f30fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f992686981383db75ae6679d65bce4ef25b813a4499ddd916d14bf9a9e610b6"
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
