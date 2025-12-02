class Condure < Formula
  include Language::Python::Virtualenv

  desc "HTTP/WebSocket connection manager"
  homepage "https://github.com/fanout/condure"
  url "https://github.com/fanout/condure/archive/refs/tags/1.10.1.tar.gz"
  sha256 "eb2df8e1a80d9fe4f66c41d2e9fbcd1205d8239ccd9b6cd914de5567356b7c70"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a4528aa522e4ddbe348f49b19bf850d4ed951fe83b1f79e7255c31bb306072d"
    sha256 cellar: :any,                 arm64_sequoia: "92dcf182f721ba12441208f5bc9e30db1e4c7b9554fdf5171fe437908b0084aa"
    sha256 cellar: :any,                 arm64_sonoma:  "46afbd4ff699d9ce78a3d21d84ca4bdd00352224c8c52e886151507a1ec42b39"
    sha256 cellar: :any,                 sonoma:        "a4e7bb7e82ba9a4b56b5576fa2436afbdc08a249498eac340b79aac364186f79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "301e1520aa5aa53f17e491deea87faba6995fefa5e02d781c8b4540fe3a1dab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6e2d3e37b6cbbb3d4b6ca8a593e6760110bd181d4e0821f3041e90fc9c9859"
  end

  # https://github.com/fanout/condure/commit/d70f63b6ed4b60e85fcbf4284a0eab964c94df38
  # project has been merged into [Pushpin](https://github.com/fastly/pushpin)
  # The `pushpin-connmgr` program can be used as a drop-in substitute.
  deprecate! date: "2025-01-10", because: :repo_archived, replacement_formula: "pushpin"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cython" => :test # use brew cython as building it in test can cause time out
  depends_on "python@3.14" => :test
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

    python3 = "python3.14"
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
