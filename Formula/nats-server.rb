class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.9.7.tar.gz"
  sha256 "eaf5fbfac1e5a07aef4d187dce8eabdffc564a60309bf7070694651cba1f5049"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce48fd805dac372b68e723f0b040ef25a05efac2c7ee4e7c385500e3f2439a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da56d0f251a705d03f0eac5fa6065ac08cefb6687beb94e8eec3ca413b7c66f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4293351c0b62e606801c11f08fedc52795b758008e0dfd56c29cc3304397204d"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5e020926005b0665745a1910bffbb7ce713cb31b8d6fbfe4af5f264afde15e"
    sha256 cellar: :any_skip_relocation, monterey:       "b5df0aece2acffa008067683e29c000ae8e0f4b037e3f3d8dc236cde429d37bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce29e92e3636ba09ee392939685dd22244e1109fc6d8c157313da58ebbd731e6"
    sha256 cellar: :any_skip_relocation, catalina:       "e6497e2c343caab847203edaf1d399cdde4f40f77f29bac7a4bec5b51dadb729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97857f22dcacc2a0cd601f1716366dc14ca7a46cfdde9042a06957d991ca1d79"
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
