class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "c7fda4db197bcde05c14e4f8fcaf88de20986519573dc0cfcc127a18d2a2cddc"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5148ef8bee593a0f11afdf6b1c1b0366cd86e1c1b4317da9ec5a1444409abf3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3168263299a8c34e266a3219c2f9f7cd10f9284e4336020e455ce9cadc036cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9102ccc21dd2bba4e6cb464aca0c5c89ad1b66019237ceb4ac6a93bec96a6993"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f1d61e1d97947218fe1b4e07500833c4ddd10fbe628b7ca67790acf2e46aeac"
    sha256 cellar: :any_skip_relocation, ventura:       "a55e0969c554cd7e99b1c2ab2540cc6a6b866566a23b6209c759d11aff859e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03f15dc71c7d36337cbd1698507190939b27724e5c91f7b879f3b316ba111fe7"
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
