class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.41.0/pushpin-1.41.0.tar.bz2"
  sha256 "1ceef0b8da5229a066906797e47795905f1fe8fb1477edc9d5799720df9943ef"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9cb6d39776602c4d4169a89d281ae69733646412b8fbbba9b9a99344ba7b31a4"
    sha256 cellar: :any,                 arm64_sequoia: "10d962ce0bcb230d74ed1749762f3979abedf90c08bc54bfa26962c29eb8e6db"
    sha256 cellar: :any,                 arm64_sonoma:  "343772a7d9955e016e3a7081bc1dabe70915a77702bf460f8f611f7452410294"
    sha256 cellar: :any,                 sonoma:        "0be6e6bb46c5d8b38368b3d2719bff619c3c68ceca932e79b3961c3825b635a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe7194d3f79941769c3b67d92ddae001ed7a5eb4bbcf50dd976729ab3c964fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b598f60bcaf636f79032f8e3d91544a495109746f7d02c7fde223e5befc4768"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "qtbase"
  depends_on "zeromq"
  depends_on "zurl"

  def install
    # Work around `cc` crate picking non-shim compiler when compiling `ring`.
    # This causes include/GFp/check.h:27:11: fatal error: 'assert.h' file not found
    ENV["HOST_CC"] = ENV.cc

    args = %W[
      RELEASE=1
      PREFIX=#{prefix}
      LIBDIR=#{lib}
      CONFIGDIR=#{etc}
      RUNDIR=#{var}/run
      LOGDIR=#{var}/log
      BOOST_INCLUDE_DIR=#{Formula["boost"].include}
    ]

    system "make", *args
    system "make", *args, "install"
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    cp HOMEBREW_PREFIX/"etc/pushpin/pushpin.conf", conffile

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end

    routesfile.write <<~EOS
      * localhost:10080
    EOS

    runfile.write <<~PYTHON
      import threading
      import time
      from http.server import BaseHTTPRequestHandler, HTTPServer
      from urllib.request import urlopen
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write(b'test response\\n')
      def server_worker(c):
        global port
        server = HTTPServer(('', 10080), TestHandler)
        port = server.server_address[1]
        c.acquire()
        c.notify()
        c.release()
        try:
          server.serve_forever()
        except:
          server.server_close()
      c = threading.Condition()
      c.acquire()
      server_thread = threading.Thread(target=server_worker, args=(c,))
      server_thread.daemon = True
      server_thread.start()
      c.wait()
      c.release()
      tries = 0
      while True:
        try:
          with urlopen('http://localhost:7999/test') as f:
            body = f.read()
            assert(body == b'test response\\n')
          break
        except Exception:
          # pushpin may not be listening yet. try again soon
          tries += 1
          if tries >= 10:
            raise Exception(f'test client giving up after {tries} tries')
          time.sleep(1)
    PYTHON

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = spawn bin/"pushpin", "--config=#{conffile}"
    sleep 5

    begin
      system Formula["python@3.14"].opt_bin/"python3.14", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
