class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "b9baa68b6763fd683ba8cddcaa2de091f06fef361e314f95cba367a77db15371"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb25e969f5d2fabda13b1d12833c11c7a5097920cfde7bded768cbba021f123c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe868a5ae16369edfdd0caec7034bec710fd78a608b63a8a4571a6452cca3ba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fb0cb390188d54d104aee606ec39a49f3e7a2c7a19ffe39033fb441ba48fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b37285485f1dc7e90730872a5e27b5e05a8922698839da5616dbf65021b02b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18bfe6c7313ce49fc11b24927bf6633e0f64778084c286d9c602a0abf4b01dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3860d29e384f93c3f1959acf37171210a88d357c54c1a00e05f983a08d459ad1"
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
