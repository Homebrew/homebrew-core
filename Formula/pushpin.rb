class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "http://pushpin.org"
  url "https://dl.bintray.com/fanout/source/pushpin-1.16.0.tar.bz2"
  sha256 "6f66603d0415697eaf94fa41fa68dbf8f19a28d101a9cf17a835c2b931bc5496"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "eb1cbde67dac20d60b19d0df7e86c91294a5bc2548a8df826d4c40fb97995d56" => :sierra
    sha256 "3bac87de514c9f806ce759c2ebc77ca87112b79c9ebe494d477429879b843845" => :el_capitan
    sha256 "c188940d042aa529613c7340c265be2fe8fba9b6fc87c181b32d69b8cc316902" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
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

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end

    routesfile.write <<-EOS.undent
      * localhost:10080
    EOS

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
