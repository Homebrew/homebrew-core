class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fanout/pushpin/releases/download/v1.34.0/pushpin-1.34.0.tar.bz2"
  sha256 "b6142650bccbc766d98782ce6489b62cf0f7d6e30784fa0b02ffa5307184d572"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git", branch: "master"

  bottle do
    sha256 monterey: "1154ee7f421ac9854e80de9b0c669726f06564f9f3d99e473f028af8ed7302fc"
    sha256 big_sur:  "80c0c9374635cbff196946f23e9d301d7a3d61c5fd333c65f79b089614bc2fbb"
    sha256 catalina: "f997d4655fd9176f796270774f20fab10686a4d9076cf67dd81e60ddc639a396"
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
