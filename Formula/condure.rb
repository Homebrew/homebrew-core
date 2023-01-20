class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.9.1.tar.gz"
  sha256 "f2b79e9d895ee43e0b6ee3523659130906fbcc630307e05414ace5d3b5f7cff2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "53d0107ac95f2fd68113b56840906a5befce9dbcd38f3ed93c79b2b9104eefe8"
    sha256 cellar: :any,                 arm64_monterey: "574ec83c1915f404ca85b4a17485d3436b9555fb5ec9cabb4fd5984823e6f8fa"
    sha256 cellar: :any,                 arm64_big_sur:  "3ffc7ba890c3b041bea9b55ba7569f3ab31c15767c7040dbb19c3e83e522d88b"
    sha256 cellar: :any,                 ventura:        "7c0eb97d6d6dfc296f17f4c14d7a9602ceade826147fdb48c480c69fa5ab3989"
    sha256 cellar: :any,                 monterey:       "bd40d90af884a344ae09dc3813045d41b02f1e8dc53cec6072d3d067e6f8ae5f"
    sha256 cellar: :any,                 big_sur:        "cd674c0e8f7429fbf82b7328082a207e934b69ae78f7a565dfd67bc0dfc20134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f3666ecf387040e73874d715b7b697560fbbbf9d06c08f0112e431e5484d08"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.11" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/cf/89/9dbc5bc589a06e94d493b551177a0ebbe70f08b5ebdd49dddf212df869ff/pyzmq-25.0.0.tar.gz"
    sha256 "f330a1a2c7f89fd4b0aa4dcb7bf50243bf1c8da9a2f1efc31daf57a2046b31f2"
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

    venv = virtualenv_create(testpath/"vendor", "python3.11")
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
