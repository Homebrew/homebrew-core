class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "506f1b9ffd5f1c19729ed6d0692858ed4d4dc77179bfa0591744df6750a559a0"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eea0514cc5c201cc7183b4bb8e063007a2f4047d50c9de8d15a41a7a2ca0297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e816ece1f66320b2e86c7ca111d1c2fe3c9c6f550290fe3b53dea590314dc841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3b671dc857197058f49c491a7ec631c4b83169916c61bfa940e3d8ca8836b2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab6d5d7d175adeda95fd6a97cbeb328336666efe459116d418dc2dfc26da7ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e01c05f6ef794f295f8fe848ae7735282155122aff08da5c2242ad339e5e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5245375efd9b7fba10dda34e08b1f5b472062c3c80c64e27cae4b6eaa83dc5"
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
