class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://dl.bintray.com/fanout/source/pushpin-1.19.0.tar.bz2"
  sha256 "75582b97bd394ac8ada058bd840cf58145b3a60e7e59b7f762a020c043b6d46b"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "5fb55f6bc07b55240a0fa841604f50c9aa3616d2249441fb1bd8f05fa8eb7e2d" => :mojave
    sha256 "c38b219e22481ddb407bd5967867f78193f97fb28a5271710d9f85bc708deed2" => :high_sierra
    sha256 "1fb41b41b4884ee44c65c71bd5c2a51df297274f6fcf83a238a5a99389ed969e" => :sierra
    sha256 "a9ccceb6206c482a8b97aea583e3fa6152885c6b2db1d1d84195da3157706e0b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "mongrel2"
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
    system "make", "check"
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
      import urllib2
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
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
      f = urllib2.urlopen('http://localhost:7999/test')
      body = f.read()
      assert(body == 'test response\\n')
    EOS

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
