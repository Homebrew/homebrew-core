class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fanout/pushpin/releases/download/v1.35.0/pushpin-1.35.0.tar.bz2"
  sha256 "62fbf32d75818b08fd8bce077035de85da47a06c07753e5ba10201a5dd35ca5e"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git", branch: "master"

  bottle do
    sha256 monterey: "2dd88fcce86708d3f04a2edd543ab64fba6b4c854abf7d3eb457d30686800253"
    sha256 big_sur:  "252f709d3a8426b95aa5bc8b05bb19da6d8b3c2cd1895d685da3334db5218eb1"
    sha256 catalina: "0386eefc82559327ab180105434304d277d69a9c475b8b46c32ca0ab68b662bd"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "condure"
  depends_on "mongrel2"
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "zeromq"
  depends_on "zurl"

  def install
    args = *std_configure_args + ["--configdir=#{etc}",
                                  "--rundir=#{var}/run",
                                  "--logdir=#{var}/log"]

    args << "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" if OS.mac?
    system "./configure", *args

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
