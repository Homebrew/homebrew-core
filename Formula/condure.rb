class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.8.0.tar.gz"
  sha256 "ac29c3d12d40f56d5e9d7ed49b14b8e6a520a25f60141b89eb679cd39b6ea4a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "102a44cde169163b6f67ecb342487e6a1cbc3ba969d37674c8ed371d7932bbdf"
    sha256 cellar: :any,                 arm64_monterey: "619997d9dbda6f45f156833bc826d2584c1e0041dac58e78fd288b21be65bc5f"
    sha256 cellar: :any,                 arm64_big_sur:  "3326dff2991200408a3be837b18132b1ac5a93ec44c1c0d68def649d14c78f99"
    sha256 cellar: :any,                 ventura:        "8e7856009c7d434e49ac872825136473934d26512b3a9d05f99bee0b49e74b48"
    sha256 cellar: :any,                 monterey:       "37afa109b757bf5100a0d70847de129fe1ffaa09ff064b36dfdacb98a3a26898"
    sha256 cellar: :any,                 big_sur:        "b5cee222443021d8a57f97566c25a04c0b61bf2d6bd8aa1b285f1358d3e88c83"
    sha256 cellar: :any,                 catalina:       "4d5f6cadddb0f6338a179b77d8e0130ca0a9387972a6544aa95193ebfc114dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e677c73b1f29cf6568d908074efad93520bf9aff2b482fc9b5ff84ad3ed42623"
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
