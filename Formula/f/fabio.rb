class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "cd80ee0dedb78e865814fd0aae311546a3bbae8ef839e636049a540fbecbf99b"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d47cd5d59eaea8d66343a85624aa06822f08a8124630bc791ddc8810b6af8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d47cd5d59eaea8d66343a85624aa06822f08a8124630bc791ddc8810b6af8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94d47cd5d59eaea8d66343a85624aa06822f08a8124630bc791ddc8810b6af8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "17585799952844e22d4fc7e77d93ea71e491130b2aa1a6472cfc4543bb729559"
    sha256 cellar: :any_skip_relocation, ventura:       "17585799952844e22d4fc7e77d93ea71e491130b2aa1a6472cfc4543bb729559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbb5f43346784800913ce53e5320c0792f4358a4294f5345241cd5977cd6734"
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
