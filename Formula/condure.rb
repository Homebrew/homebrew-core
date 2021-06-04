class Condure < Formula
  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.2.0.tar.gz"
  sha256 "0372b925558ed966df0657b18c0c91b1e1d1ed789c59e572728722569e504fb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f5fe1e3d3986b9094cd4c9dd47c723c34be95569a48d17ea65f35772f82ea38d"
    sha256 cellar: :any, big_sur:       "2daf0a91d666cdd8ac6defd4d603e86d1f8619e936b2c58299d86b2d08e9345e"
    sha256 cellar: :any, catalina:      "369a5eac6c74ac9e579b3f52fea9ca7b7359499bc3f0926d96285fdce0ce6168"
    sha256 cellar: :any, mojave:        "5bcbf91da877662c3407ef78db0eeaf8a42c9aa51885db95203fca9d3d01c955"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.9" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/a3/7a/561526861908d366ddc2764933a6090078654b0f2ff20c3c180dd5851554/pyzmq-22.0.3.tar.gz"
    sha256 "f7f63ce127980d40f3e6a5fdb87abf17ce1a7c2bd8bf2c7560e1bbce8ab1f92d"
  end

  resource "tnetstring3" do
    url "https://files.pythonhosted.org/packages/d9/fd/737a371f539842f6fcece47bb6b941700c9f924e8543cd35c4f3a2e7cc6c/tnetstring3-0.3.1.tar.gz"
    sha256 "5acab57cce3693d119265a8ac019a9bcdc52a9cacb3ba37b5b3a1746a1c14d56"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ipcfile = testpath/"client"
    runfile = testpath/"test.py"

    resource("pyzmq").stage do
      system Formula["python@3.9"].opt_bin/"python3",
      *Language::Python.setup_install_args(testpath/"vendor")
    end

    resource("tnetstring3").stage do
      system Formula["python@3.9"].opt_bin/"python3",
      *Language::Python.setup_install_args(testpath/"vendor")
    end

    runfile.write(<<~EOS,
      import threading
      from urllib.request import urlopen
      import tnetstring
      import zmq
      def server_worker(c):
        ctx = zmq.Context()
        sock = ctx.socket(zmq.REP)
        sock.connect('ipc://#{ipcfile}')
        c.acquire()
        c.notify()
        c.release()
        while True:
          m_raw = sock.recv()
          req = tnetstring.loads(m_raw[1:])
          resp = {}
          resp[b'id'] = req[b'id']
          resp[b'code'] = 200
          resp[b'reason'] = b'OK'
          resp[b'headers'] = [[b'Content-Type', b'text/plain']]
          resp[b'body'] = b'test response\\n'
          sock.send(b'T' + tnetstring.dumps(resp))
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      with urlopen('http://localhost:10000/test') as f:
        body = f.read()
        assert(body == b'test response\\n')
    EOS
                 )

    pid = fork do
      exec "#{bin}/condure", "--listen", "10000,req", "--zclient-req", "ipc://#{ipcfile}"
    end

    begin
      xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
      ENV["PYTHONPATH"] = testpath/"vendor/lib/python#{xy}/site-packages"
      system Formula["python@3.9"].opt_bin/"python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
