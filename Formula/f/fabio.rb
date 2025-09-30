class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "82c5fb6c78171e33f95f6ea6b4be68f2e94e87cb849cdc50b403ca573d2291e6"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576b2145a0ec4aa9b572068ac1cd17668147adf1a75f7a5558cbb5438891bb2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfa157e62af4a72a0566e6e5e84fd573fea4172f54a55aed94103d2a9e7ff82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9007492471b2bdaf6cda1d301ae731e3886a5ef470236368b28b08a18abb1ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "edecd321f12a9488083d023d3f481d886dd3dd8772a00cd8af2bbf0c814be320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f40302d0cdfd4d4061bd3f33cf755126dfb8451a7b78ed49efc6719ffb72ea3"
  end

  depends_on "go" => :build
  depends_on "etcd" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    fabio_default_port = 9999
    localhost_ip = "127.0.0.1".freeze

    pid_etcd = spawn "etcd", "--advertise-client-urls", "http://127.0.0.1:2379",
                             "--listen-client-urls", "http://127.0.0.1:2379"
    sleep 10

    system "etcdctl", "--endpoints=http://127.0.0.1:2379", "put", "/fabio/config", ""

    (testpath/"fabio.properties").write <<~EOS
      registry.backend=custom
      registry.custom.host=127.0.0.1:2379
      registry.custom.scheme=http
      registry.custom.path=/fabio/config
      registry.custom.timeout=5s
      registry.custom.pollinterval=10s
    EOS

    pid_fabio = spawn bin/"fabio", "-cfg", testpath/"fabio.properties"
    sleep 10

    assert_equal true, port_open?(localhost_ip, fabio_default_port)
  ensure
    Process.kill("TERM", pid_etcd)
    Process.kill("TERM", pid_fabio)
    Process.wait(pid_etcd)
    Process.wait(pid_fabio)
  end
end
