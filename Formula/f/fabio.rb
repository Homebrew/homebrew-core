class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.11.tar.gz"
  sha256 "398bc949184e35dc0da804aba5be3c10678c1730c2b94fea437b6b886dd5977d"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1784e73f50e1b576f78e661507a2c189a0a57c51c3f5b5464794a69ca8430d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9768d8267cf99ae0cf4e96c841e2abf8ae54211300bdde922f33d53372412dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "179379fcd479f898dc01649161f43505897be61eb53ac8e68aa041082ea6e874"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba3a9cd68eafd9f4aed2201b045f44a7cda56c1220cb3066921db905555eb8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fdc9386023faba3ca5b7e8ddbcf13dbbec47ea95dac5c55b942289e94ab0471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83579a87c6f1a8facf7c525c4199236df0207ad70f3d23b25d5d3e098afca960"
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
