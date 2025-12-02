class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "ee945d7de14bf24dbf1ecb33633ff5d694595bfa896c3c436182efe9f361f927"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "043da49e66fa519ecd0504dd6c663f3f8e3c75fa237bf15a5b2299d568bb754b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8a56e2a2c554327d406665d440d88cb6a0ce0188ed838e0158663cc75df397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2beb147cd6cfe5b4e206050ef8ad68a9b2b2f164e5c360b4040018aca0a544f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "09a1bc8645d8bb17fce2992cd8cd5e3da6f86975c4bd204293c9ad7e23e25012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a4f45a29ed43310b0d4b90de3da4f3714ffb76a41c3b8cd76f91cc81c11d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d92e707b19ab4ce931502495382a689ef158f4447e828bdfa574ae44461278ec"
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
