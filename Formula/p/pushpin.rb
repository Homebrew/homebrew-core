class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.37.0/pushpin-1.37.0.tar.bz2"
  sha256 "5fe5042f34a7955113cea3946c5127e3e182df446d8704d6a26d13cde74e960f"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    sha256 ventura:      "a14bd996772ffd8d662690864e7412135fd3fa50df4d953694969d02280971ea"
    sha256 monterey:     "9b7ffe6547bb8bf7790b64d0ca0fb81a85d069dbc5bf8782606fd670afa730e6"
    sha256 big_sur:      "c382905cb6068f69fb4af65a0f5fcefd441519d1fb186d4ffbe048126e701b82"
    sha256 x86_64_linux: "2e3da86aaf8b0bd905cac0ec5291e6ea2e111c287cc44b68a9b05333287a8bce"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "condure"
  depends_on "mongrel2"
  depends_on "python@3.11"
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
      system Formula["python@3.11"].opt_bin/"python3.11", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
