class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://fabiolb.net"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "2de8fc98a9b67f6a6832e25dfc739d0f6b83e7d5e5cd47464e35d431c59c5f66"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75a5f708981a966b190d40f1ab801ec9323d23b3a768396294644d2b04636036"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "305f60df381058cb7b8290a6568a5f626e6c6859a183c0246c1f2b69c8a6ac11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c7c202047c451df468c9fae9232447d54e15ed786cd5ab286b4456b4952b712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e375db48b86144d5beb802cc508de623336fdeb9a3241546c5dc537b5d9fc1e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b315d2d497dd093ca98b5c23ca7645f766bc61e3441e9fe3fa859800429e8ce2"
    sha256 cellar: :any,                 x86_64_linux:      "6e6e50f2e26a61136eee38547f4be6b668fa9aee6a1af890b7a083a4cccdddda"
  end

  depends_on "go" => :build
  depends_on "etcd" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
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
