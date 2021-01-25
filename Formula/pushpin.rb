class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://dl.bintray.com/fanout/source/pushpin-1.31.0.tar.bz2"
  sha256 "62504863297a8ec1833486affaff91fade7a970dd43b9c8c2add5944603481ac"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "2ecabfaf77c7baa3a348b52c04e5d631decf56497f9c243308a4d3ecde956962" => :big_sur
    sha256 "cba8efdcbb2ce8e426ff46e450fbc686653a902f17d9cd7eb940be072e14914d" => :catalina
    sha256 "466d8d74ad32796a9d6d1aa1ea19746570d6f5a6763d55ba829c01b9c6ea4656" => :mojave
    sha256 "326bb88e58a9ab6087ce7c4de8097f62cae5930c2dd469fe847760c467761b94" => :high_sierra
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
