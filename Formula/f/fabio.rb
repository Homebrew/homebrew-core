class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://fabiolb.net"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "dd329eb7ef6dfca110bcc0f0510f5a6ce6286ae5f9217fc6250db4c81875eae2"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fd8730b0fcc306818ef43c1bea53210008ecd30a686ba66fbd34cf174f71d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bafeceffe079baa1dd812eda4536f06874c526189b03f2f6f672420227aef847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9371f7f607fd7fafdccd9bae173e512d168abcdc3d67119641e672640867da45"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b596bffcfd4cd2e59f845a937d735618c1c96c8dd5375d15410195b0f81233d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ac5dd704ebe8773269ba1aa640f5c2d9ce8ad9406c4d414a111b605a7a7eac7"
    sha256 cellar: :any,                 x86_64_linux:  "bf9732ebc51ade4f6994db9e2d72c1de04aee150588453df433c29e6132fcd88"
  end

  depends_on "go" => :build
  depends_on "etcd" => :test

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
