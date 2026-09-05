class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.42.0/pushpin-1.42.0.tar.bz2"
  sha256 "9ac513757b41511d26cde151b61894201903e73ec003877f667e9c2d1307184e"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "2b5aeb85a438bc413a92149daa304f26836526ff92256c07c70ed041251d4422"
    sha256               arm64_sequoia: "83c631e870b574182bc1d9e4edf110f7db80888ec892d3273737e37027a473bc"
    sha256               arm64_sonoma:  "a14bc5d6d6e34e0c8091a0fbc71c8fbe7a2c57d596775a490457194b983899d2"
    sha256 cellar: :any, arm64_linux:   "52ee3c376104c3969775cd9abc56a95c8e71e13a289d2b88b521f76f6de738f9"
    sha256 cellar: :any, x86_64_linux:  "6952b44e67eb4b1c62e5ef62ac6aae32cd014623fac5c99b946ab78672db2b36"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "qtbase"
  depends_on "zeromq"
  depends_on "zurl"

  def install
    # Work around `cc` crate picking non-shim compiler when compiling `ring`.
    # This causes include/GFp/check.h:27:11: fatal error: 'assert.h' file not found
    ENV["HOST_CC"] = ENV.cc

    args = %W[
      RELEASE=1
      PREFIX=#{prefix}
      LIBDIR=#{lib}
      CONFIGDIR=#{etc}
      RUNDIR=#{var}/run
      LOGDIR=#{var}/log
      BOOST_INCLUDE_DIR=#{Formula["boost"].include}
    ]

    system "make", *args
    system "make", *args, "install"
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

    runfile.write <<~PYTHON
      import threading
      import time
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
      tries = 0
      while True:
        try:
          with urlopen('http://localhost:7999/test') as f:
            body = f.read()
            assert(body == b'test response\\n')
          break
        except Exception:
          # pushpin may not be listening yet. try again soon
          tries += 1
          if tries >= 10:
            raise Exception(f'test client giving up after {tries} tries')
          time.sleep(1)
    PYTHON

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = spawn bin/"pushpin", "--config=#{conffile}"
    sleep 5

    begin
      system python3, runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
