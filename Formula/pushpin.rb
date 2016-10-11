class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "http://pushpin.org"
  url "https://dl.bintray.com/fanout/source/pushpin-1.12.0.tar.bz2"
  sha256 "362fb8df65b13560525d5ed22f817b595529728ae0fe612ec2a5c9e4cd8aea8b"

  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "dca61c123a38013190205decbabb8bfec822bd797c95683a71a94d21fb2c68c9" => :el_capitan
    sha256 "f2aa3c2499d6d8734fcab629c66763c13c1848da0a530cab3f8a30e2d22252f4" => :yosemite
    sha256 "9db77cca5ceca4e05b4795242c5647fdcf563247f669a565f6a5ef41a2d22b18" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "qt5"
  depends_on "zeromq"
  depends_on "mongrel2"
  depends_on "zurl"

  def install
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
    cp HOMEBREW_PREFIX/"etc/pushpin/routes", routesfile

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end
    inreplace routesfile, "test", "localhost:10080"

    runfile.write <<-EOS.undent
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
