class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.9.2.tar.gz"
  sha256 "c95a7587997af82ab6f3bbf92cfb983b58d7c304133f3be1d0787e31d16ea065"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f1303c7f4e4fda6887b2d444d81bba105f462cb9b689115d335540c7505d57e3"
    sha256 cellar: :any,                 arm64_monterey: "b2118a43f01eca57f002b5f9705ae11faeb10afb2a263c4fbe717328a03f6e5d"
    sha256 cellar: :any,                 arm64_big_sur:  "b64f7dd122a8d0b88befd32b2e35a1c6f155ca0ee14b0b828bbee0245ce151ef"
    sha256 cellar: :any,                 ventura:        "9cd462ef606149e0c05e82e0af59e7c91d4f7d9bec5bf31431dce5548e3c74b6"
    sha256 cellar: :any,                 monterey:       "1d84c3a753d9e094d91e1a20d215d49c3cbbfa859b3594d17932679b56f8f599"
    sha256 cellar: :any,                 big_sur:        "3199452c7dfc3b4bb8ef6dd50c5ed0fdb5de1a9fb68f1fef7a206b25c9f3a59a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914119485fc92b4979990cbb295de42e3b9653b6ff5c5217d01070725d5e8fb5"
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
