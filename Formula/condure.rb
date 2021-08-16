class Condure < Formula
  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/1.3.1.tar.gz"
  sha256 "26945c241c1fd352757d9e747ba7cc1906c9d17b1b8de5936b372a183c3bf5ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0e2e6333e04b7815f37e06a34ef3fca4f7a3c6e74b2cbbfe393a45077392161f"
    sha256 cellar: :any,                 big_sur:       "43695f08e129f583447199a2f7cc744aa85ae79a8944c3a09f2af273f6f86929"
    sha256 cellar: :any,                 catalina:      "2bba408b0a94fad0d0444baec011db022fb3bd6cb3374d524f67bd9878f3cc4d"
    sha256 cellar: :any,                 mojave:        "bbfd3f576f111e2793bc3976d8fa129410fb719cf7ff62352780a6df7e12c17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd417c36ce2b305ca47c17bbd9a19960e2ac6f8b3e92d56120202205b8b9bc8e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "python@3.9" => :test
  depends_on "openssl@1.1"
  depends_on "zeromq"

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/99/3b/69360102db726741053d1446cbe9f7f06df7e2a6d5b805ee71841abf1cdc/pyzmq-22.1.0.tar.gz"
    sha256 "7040d6dd85ea65703904d023d7f57fab793d7ffee9ba9e14f3b897f34ff2415d"
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
