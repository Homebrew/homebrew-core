class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.8.0.tar.gz"
  sha256 "ac29c3d12d40f56d5e9d7ed49b14b8e6a520a25f60141b89eb679cd39b6ea4a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1030408f7784b124a187130f04d096a089b3e89675f50f08b512d40eb8310523"
    sha256 cellar: :any,                 arm64_big_sur:  "cf17625a77e47278dbcfcc68ba0eec040080976641c93851ef41e5309a715efb"
    sha256 cellar: :any,                 monterey:       "2d77e63d5307612fa4a93edcb935777dd4312e688ffc563541e17325527ff35b"
    sha256 cellar: :any,                 big_sur:        "345e93d43f1ca1d4e0c60ccaacdf47a12d583725daebcf956928c238eb628f85"
    sha256 cellar: :any,                 catalina:       "44ca84ed977424ef1d8d2edd84d5a5e9b105f0f55a34c102e9e36b2a3692b4c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a364fff377b21ca26057de61082b7db2a6d65a38d631c44e9e4d1f697faa11f6"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.10" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/72/37/d5603f352522e249e44ee767a8a59b3fe7cf7f708a94fd40a637c6890add/pyzmq-23.2.1.tar.gz"
    sha256 "2b381aa867ece7d0a82f30a0c7f3d4387b7cf2e0697e33efaa5bed6c5784abcd"
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

    venv = virtualenv_create(testpath/"vendor", "python3.10")
    venv.pip_install resource("pyzmq")
    venv.pip_install resource("tnetstring3")

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
      system testpath/"vendor/bin/python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
