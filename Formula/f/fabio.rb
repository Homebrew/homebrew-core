class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://fabiolb.net"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "46b874107a81b9b843c4617ca9a5da395f69f666c9c92f19b192bcdf2aab22db"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d82cdeff2ddfbd1164d10723eb85dc26b4ae1885263308d65710aa7d273187bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e151074df3bc38ae9f1afd9a72a3bb29a0bb42cfbb78cc33d4262d72335e5b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e1388dffe8b1891c2e2e635ed2dcb4d2b0686165c4567c1f6af78992552caf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "56182ee184d918deb31ea651451469770ca749bd7ca225bce9fe7701cf394c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d82380bb893e683dd7c23c5aedda2be9131eeaf92027977228f67fdae1ecca15"
    sha256 cellar: :any,                 x86_64_linux:  "206bf47b1cb4a8d6deb1b2bb594dc9c07c3004abd71373236a8d6d32fc6bef5b"
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
