class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://dl.bintray.com/fanout/source/pushpin-1.28.0.tar.bz2"
  sha256 "3c0e9cc392d560eaf20459d1a3ddbfd9d8ad0453e1fd25ec993a8ce16f369aaf"
  license "AGPL-3.0"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "7a458b9e568c40b09e309c3250e627768854060b3de9fd4fab8cb29b6a20fcb4" => :catalina
    sha256 "4214e500fbecfdec4aedfea47e230c87debfc86a6af123d7516e5d3ac6d2a6a7" => :mojave
    sha256 "822e79bdee9741ee4ba98dde6db15ef5263cd2159f04919f05a8914365f9f277" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "mongrel2"
  depends_on "python@3.8"
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
      system Formula["python@3.8"].opt_bin/"python3", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
