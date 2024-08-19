class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.40.1/pushpin-1.40.1.tar.bz2"
  sha256 "64b6486160ecffdac9d6452463e980433800858cc0877c40736985bf67634044"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e5a25a6a9f938389eb5c79fd9cfb34e2c32b21d47b9ba3298a9663cd2d226658"
    sha256 cellar: :any,                 arm64_monterey: "db4f9f00d9f1c8a25f84d97cb4ff4fc76e5c52cb4066840d5dc8c84f6417436b"
    sha256 cellar: :any,                 sonoma:         "91b627cae4341f2a020902c8e4b199bb7f0df6cc65be8d6693c78e9df80b6e04"
    sha256 cellar: :any,                 ventura:        "be07922ebf6f03ef1e54174b3ccfc192d3e9a4b043099f2f5eb7b484eaf3738e"
    sha256 cellar: :any,                 monterey:       "d76c6ab9088e1f5579ddcbf2b623bf986407b17b8776f82e8765e5b2d36f55eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3a98c98a38e3d4d7e1b65f4e5a080f42293ac2bb28522c06e52dc1bf46f7a00"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "qt"
  depends_on "zeromq"
  depends_on "zurl"

  on_intel do
    depends_on "mongrel2"
  end

  fails_with gcc: "5"

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

    runfile.write <<~EOS
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
    EOS

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = fork do
      exec bin/"pushpin", "--config=#{conffile}"
    end

    begin
      system Formula["python@3.12"].opt_bin/"python3.12", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
