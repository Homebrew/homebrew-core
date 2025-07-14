class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "846ac67c68b41428586f28183f772b5a3d5a9003b21625bc6f0f0ed361c8a890"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31bc78f40b86f6687211aece737253a395f1f052d9b489b5d1bb5dcb2b434b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61cd285af8c4af56ded6264910244e04e6f3473053d0276892df2b9fcb694bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abd359ebaafe391dc7747a40efee2e9afc96da013f32ec05892396b251d0c402"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ac7d11c7b8d2a319ddf65a6aeb22c5518c6da3881b16c1a18b98ca75dc5dbf2"
    sha256 cellar: :any_skip_relocation, ventura:       "3b4717f13ab398f9cb648db3cf8ee0c2c692f0255ffe050f2e706085c23efa13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6037cb7efd47d8b75ab54327b54a8505cba26c0f8b8cbd7be90a4aaf96fda4"
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
