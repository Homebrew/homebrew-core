class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fanout/pushpin/releases/download/v1.35.0/pushpin-1.35.0.tar.bz2"
  sha256 "62fbf32d75818b08fd8bce077035de85da47a06c07753e5ba10201a5dd35ca5e"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/fanout/pushpin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 monterey:     "0b1119064e1e2cc338ea35d18f01a88a4aaad9408db882a898e2d4127f2358d8"
    sha256 big_sur:      "42cf1df0a04539868418c8b3ed29fd5e9fbbd933c405e907b8262fbb7ca11dc8"
    sha256 catalina:     "401f642b6fb4223407cd63f18967744b6b2e3d70a88b972f10da3fcb6d20a882"
    sha256 x86_64_linux: "4acf0c75aae33b6f2469145ff7e246c85714a786c3e148923006cc91257cad1c"
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
