class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://dl.bintray.com/fanout/source/pushpin-1.31.0.tar.bz2"
  sha256 "62504863297a8ec1833486affaff91fade7a970dd43b9c8c2add5944603481ac"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "be8cda3b9dfdfa9713e21c804bfd8bc296897974804c5a70bd728e02129abb43" => :catalina
    sha256 "1f11e7e339e8aebdbc58903aed375f6e8dc2f98eb2d9a0ae41376331ea62cd26" => :mojave
    sha256 "2d446d6619eb58aa7b464c98b16468695242c009d42a3298b18e1fc6cbfe41b5" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "condure"
  depends_on "mongrel2"
  depends_on "python@3.9"
  depends_on "qt"
  depends_on "zeromq"
  depends_on "zurl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--configdir=#{etc}",
                          "--rundir=#{var}/run",
                          "--logdir=#{var}/log",
                          "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "install"
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
      with urlopen('http://localhost:7999/test') as f:
        body = f.read()
        assert(body == b'test response\\n')
    EOS

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      system Formula["python@3.9"].opt_bin/"python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
