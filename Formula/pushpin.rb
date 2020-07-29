class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://dl.bintray.com/fanout/source/pushpin-1.30.0.tar.bz2"
  sha256 "927d83919d193e19e03d9217ece495c1a5c22bfcc344b19a6e948d206c3e1ddc"
  license "AGPL-3.0"
  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "ab15386bc94ed44214d35bacd5a388a754ad44b7856f8abb8ef474c5e8802d01" => :catalina
    sha256 "1171436a1fd2a21a5e680a5869e591a4fa621d27eba1084808f87d75767e4767" => :mojave
    sha256 "924e1cdfbd54f9ea004b06d4bf80f618c73b4f54e3903525bac4feb666c9bf50" => :high_sierra
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
