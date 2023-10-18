class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.10.0.tar.gz"
  sha256 "abe4d83ae2494a8eabd036f6f455fb4d8ebc71b29d8d50a0b35a7a59f8e0ea60"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7cbf1b4f07f0fa4abf5253d02beb7445118f5b9fd6dd765c3cd802f53a6141d3"
    sha256 cellar: :any,                 arm64_monterey: "3ff53263a687653623e67c2bbc2d8cfaac6dd39ecfa66aa5b575299f753fd3b9"
    sha256 cellar: :any,                 arm64_big_sur:  "9e21d650e79b5f518e5d56456a9d8f44fe4d9a05e19aa7d95f998cbff1e91d43"
    sha256 cellar: :any,                 sonoma:         "8dd6d8f11317644b9f5fc0d3a25a111eff3dd3f212b6fd282adfc18e7ba1b763"
    sha256 cellar: :any,                 ventura:        "edc995c5d6f9c12116e79642aa8c24e1e6d1c407a58caa16efa2f76b7f0b3efc"
    sha256 cellar: :any,                 monterey:       "2522ab36941f43986b4428cc8bbb8656d579ba236fbde045541fecaf3307d395"
    sha256 cellar: :any,                 big_sur:        "f734cdba37663a940a6de71bc6be83796672ecbcfa9bdd9ee6f310d90498c121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79ea18827bcdbb96cba73940736977c56af5895db6db9af0f318ad76a58321e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.11" => :test
  depends_on "openssl@3"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/64/9c/2b2614b0b86ff703b3a33ea5e044923bd7d100adc8c829d579a9b71ea9e7/pyzmq-25.1.0.tar.gz"
    sha256 "80c41023465d36280e801564a69cbfce8ae85ff79b080e1913f6e90481fb8957"
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
