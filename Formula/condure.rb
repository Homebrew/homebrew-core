class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.6.0.tar.gz"
  sha256 "74c2fd5a165b9f7b1e255b17f07971ae33537a35b3c7bca9f10f57e840e4b7a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f159535c454d4118afa3cc250e19c4d6cee6f3f20727d41963af040d15c7c6e6"
    sha256 cellar: :any,                 arm64_big_sur:  "6ba83ee58520e1820b6904f879a11464b123c1eb58cd9943819f8a0c851c1fb3"
    sha256 cellar: :any,                 monterey:       "d76c2cb36024143d585622daee20f20e811c815552c07a2b1757ab594bf113ce"
    sha256 cellar: :any,                 big_sur:        "5982e3bc28672c233943c2afe0fc3131843fdfe74dca3ecd988ca54be39ff7ad"
    sha256 cellar: :any,                 catalina:       "8d8c158d451781eda59bf013bf49f90a5bf1bccb4f3cfc430c250287f61b4377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9027d4c4e99d35ae204df251ba36787e9869da849db6202002c28f43ea7800ff"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.10" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/6c/95/d37e7db364d7f569e71068882b1848800f221c58026670e93a4c6d50efe7/pyzmq-22.3.0.tar.gz"
    sha256 "8eddc033e716f8c91c6a2112f0a8ebc5e00532b4a6ae1eb0ccc48e027f9c671c"
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

    venv = virtualenv_create(testpath/"vendor", Formula["python@3.10"].opt_bin/"python3")
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
