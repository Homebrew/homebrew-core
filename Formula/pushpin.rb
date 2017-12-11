class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "http://pushpin.org"
  url "https://dl.bintray.com/fanout/source/pushpin-1.17.0.tar.bz2"
  sha256 "3cd1d869dced330af712d64f72e18a80545bdd60f96c6af83c0cdd7c6ba8f416"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "b3fb2d68965c52057f290fe6dfb5aed85902052a00b2e32248a3dda1b66b7e23" => :high_sierra
    sha256 "810b474f85f657447250cabefc61cbe6c453cb237458ae884d64717a499d3e4a" => :sierra
    sha256 "4dba2208e2718a64ed9e646d02edfd32420b848be151a14aecb746665a183753" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "zeromq"
  depends_on "mongrel2"
  depends_on "zurl"

  def install
    # Fix "Unable to find the 'qmake' tool for Qt 4 or 5." wit Qt 5.10
    # Reported 11 Dec 2017 https://github.com/fanout/pushpin/issues/47651
    inreplace "configure", "?.?.?)", "?.??.?)"

    system "./configure", "--prefix=#{prefix}", "--configdir=#{etc}", "--rundir=#{var}/run", "--logdir=#{var}/log", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
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
