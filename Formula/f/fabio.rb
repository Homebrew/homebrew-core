class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "8a016466658ac16e8205151aa33aa24e705a2ca9c5f76b69b6738ba7a5e03553"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "068df268ba7bbd48404abf5a80069faf08c1338d29fbe0405ca86e7d2ec2b8d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e964cd3bf61676202c3e7bb031aa2d2f2ed859e9c11763ef057dcda7e6ea7b47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60bf1f6aef00900811077bff6351b50bf00bb184ce74640fd05634737e83093a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2924e86565a63ec0a3efb1adadf6536eba2fec5b927cd147439164d0467295a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d201592c1523061a3efbdd8b6f09298c709200a5f1b7b16a4b71403ce74cfa3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb70040cdbe9a0ba7c5444912d26c0d6cb0fcbbf1aaf40d5e3c1dc2d3aa87489"
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
