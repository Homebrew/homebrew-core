class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fanout/pushpin/releases/download/v1.36.0/pushpin-1.36.0.tar.bz2"
  sha256 "9f8243e9b4052a4ddc26fed5e46a74fefc39f0497e5f363d9f097985e8250f8e"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git", branch: "master"

  bottle do
    sha256 monterey:     "f8f10a253ee4924c2c567262947ae94a9be9375329c7a5d3d8bc3f24a1d8d093"
    sha256 big_sur:      "b9bd3866895d340453cf9d45dfef6cd60eace67d54fb4dcea1b90078461419ba"
    sha256 catalina:     "ae9302317756f34243ed218a0c16a5576085ac4a537415e82d88ce95d91b30b8"
    sha256 x86_64_linux: "db4a5f53106cbf72d01112736058598b87611614eaaaed32eaf5cb910dcefbe9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "condure"
  depends_on "mongrel2"
  depends_on "python@3.10"
  depends_on "qt@5"
  depends_on "zeromq"
  depends_on "zurl"

  fails_with gcc: "5"

  def install
    args = %W[
      --configdir=#{etc}
      --rundir=#{var}/run
      --logdir=#{var}/log
    ]
    args << "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?

    system "./configure", *std_configure_args, *args
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
      system Formula["python@3.10"].opt_bin/"python3.10", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
