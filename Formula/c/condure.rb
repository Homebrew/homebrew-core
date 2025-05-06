class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/refs/tags/1.10.1.tar.gz"
  sha256 "eb2df8e1a80d9fe4f66c41d2e9fbcd1205d8239ccd9b6cd914de5567356b7c70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5dbd83cd3a803509a0cc5b3d0cdc7d3dbe09cc47ea085d2576e35852aa13f40e"
    sha256 cellar: :any,                 arm64_sonoma:   "b61e13bb29181ff457ce6a5b1b9156d370a31fabfd61767f94dfbef580469c7a"
    sha256 cellar: :any,                 arm64_ventura:  "a3d123a19dc1da1b031ae987ea84a517e3d1d6940206dce616e40a1122c3ac57"
    sha256 cellar: :any,                 arm64_monterey: "4fd31572d6268c0d6bcc5993b23f50a7f75306316ddc3ed0cfe6dd7ed439d325"
    sha256 cellar: :any,                 sonoma:         "75aa7ff3919f0791a751778e0993d8244dbad023c92bee2a7c03cf2b18fb4751"
    sha256 cellar: :any,                 ventura:        "d5b7fd6e1d9572b673a1e4e2b5662c050009f439c9dcaddf69ed07346b49d231"
    sha256 cellar: :any,                 monterey:       "f44417d181f8cc64156a2d25910ff6ced2829011b6b7e52c36abe8fea9392392"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fa34dc178dd11de4c03e5a72351aa73b8f82e2ea07d295b41e3403e3a50e2436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00527a59f46952f13cb4a1af03af0dcf3d894dd1582828bcb3152ab5b070ac93"
  end

  # https://github.com/fanout/condure/commit/d70f63b6ed4b60e85fcbf4284a0eab964c94df38
  # project has been merged into [Pushpin](https://github.com/fastly/pushpin)
  # The `pushpin-connmgr` program can be used as a drop-in substitute.
  deprecate! date: "2025-01-10", because: :repo_archived, replacement_formula: "pushpin"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.13" => :test
  depends_on "openssl@3"
  depends_on "zeromq"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/3a/33/1a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341/pyzmq-25.1.2.tar.gz"
    sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "tnetstring3" do
    url "https://files.pythonhosted.org/packages/d9/fd/737a371f539842f6fcece47bb6b941700c9f924e8543cd35c4f3a2e7cc6c/tnetstring3-0.3.1.tar.gz"
    sha256 "5acab57cce3693d119265a8ac019a9bcdc52a9cacb3ba37b5b3a1746a1c14d56"
  end

  # Apply Debian patch to fix build on arm64 linux
  patch do
    url "https://salsa.debian.org/rust-team/debcargo-conf/-/raw/de3f91dfb0ed10587e653ee1f96dca16d710eb5c/src/condure/debian/patches/fix-build-unsigned-char.diff"
    sha256 "00ce6b20a13086fca07756d0aaa19c3280a411c29abb221cd8233f006bf0496e"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ipcfile = testpath/"client"
    runfile = testpath/"test.py"

    python3 = "python3.13"
    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python3)
    venv = virtualenv_create(testpath/"vendor", python3)
    venv.pip_install resources.reject { |r| r.name == "pyzmq" }
    venv.pip_install(resource("pyzmq"), build_isolation: false)

    runfile.write <<~PYTHON
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
    PYTHON

    pid = fork do
      exec bin/"condure", "--listen", "10000,req", "--zclient-req", "ipc://#{ipcfile}"
    end

    begin
      system testpath/"vendor/bin/python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
