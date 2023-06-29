class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.9.2.tar.gz"
  sha256 "c95a7587997af82ab6f3bbf92cfb983b58d7c304133f3be1d0787e31d16ea065"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ecd9ad7efc7e43c961cbb3042ac6e10848a3c573968e96ba72746a1a7e2278b4"
    sha256 cellar: :any,                 arm64_monterey: "e4dae06297524f01869452c2f8e3f56c465ccddc08237933760dd6be284bd611"
    sha256 cellar: :any,                 arm64_big_sur:  "ba27cadd227040f78158a770d5190decb65547a02fac55a30716e693013420ff"
    sha256 cellar: :any,                 ventura:        "c9f4653f19db275a8f3995baa111260523185ee3f13b4fbcbd298de43235b67a"
    sha256 cellar: :any,                 monterey:       "14cca7f6f12a2776fa168011e995d812b90f6cec65960d87ef53fee161393aee"
    sha256 cellar: :any,                 big_sur:        "86d06d5faf329d248568d68e748ef48c4506f874f82dd3021e7512cab2d15002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea299a2cba77989fe144a3d45bdb325007516437668a65c60f059e81c4aeff8f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.11" => :test
  depends_on "openssl@3"
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
