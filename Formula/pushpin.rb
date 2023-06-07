class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fanout/pushpin/releases/download/v1.36.0/pushpin-1.36.0.tar.bz2"
  sha256 "9f8243e9b4052a4ddc26fed5e46a74fefc39f0497e5f363d9f097985e8250f8e"
  license "AGPL-3.0-or-later"
  head "https://github.com/fanout/pushpin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 ventura:      "812691f678a11153b1c81bc116a5ffb3e16f71d8c55ebefb1684e2215c7d91c6"
    sha256 monterey:     "ce250ecc703f631f4a613ac6e2fe8a63e8eef24e49af5dfa0cf1c4683fbd68f1"
    sha256 big_sur:      "f553c2932f6650caa39126bc0fab6bda2c2a2394ade2fd292196bc683b461198"
    sha256 x86_64_linux: "512449c5c34beb705907ff40485f8d0a7ca80c6a6dcc24c174b50af2f63ea0f9"
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
