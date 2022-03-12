class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.5.0.tar.gz"
  sha256 "00dba95f2f60438298ab4f0d937f7d8d04f4b04d9cfcc5cf6cd8b2ef3c915e3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d88b01fcf4a606b6f20cda55d843b205e6f53a922c81efcca1b77676784a83aa"
    sha256 cellar: :any,                 arm64_big_sur:  "29e29f637e951e2194833b85ba2c98a6c57d249d7b5b4886ba8efc78aae5569a"
    sha256 cellar: :any,                 monterey:       "8e4cb7af66ec7af503cdacceb4efea7be57c7dd2265296693bffafda554a5937"
    sha256 cellar: :any,                 big_sur:        "c5b2b9ddac9e3ceb87fb4f7044fd435cbad48132c95b6814d29a6491937e1551"
    sha256 cellar: :any,                 catalina:       "4a55cc68169bdb6dc2191f7ffd27fd518da40c44291845ad28fdf2761c61086a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb6932fae016b35e807aa0d2303e8cf6306f01da7cd5f5243d1944b795ef54c"
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
