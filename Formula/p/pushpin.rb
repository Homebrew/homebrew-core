class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  url "https://github.com/fastly/pushpin/releases/download/v1.40.1/pushpin-1.40.1.tar.bz2"
  sha256 "64b6486160ecffdac9d6452463e980433800858cc0877c40736985bf67634044"
  license "Apache-2.0"
  revision 1
  head "https://github.com/fastly/pushpin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "1d120efbfadd608cd604b66470462a3e4488f69b86e46808797d230d25790303"
    sha256 cellar: :any,                 arm64_ventura: "0e40cbd84d4f05265640af260ebe60817491fc1025aa38589912ece4b4ee7998"
    sha256 cellar: :any,                 sonoma:        "77d2d0fb0619c56b39c9cef7ffcc21d41a47be7b9886842feb157164090c336d"
    sha256 cellar: :any,                 ventura:       "a9eb99d74245913f4e521c113fb5b2abcdd6ad97db162f86abae790efb27534f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848d95a2cf6027fd9c0bdb99b34fe0d7a70b86784a40365bd7c432506b70e2e2"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "qt"
  depends_on "zeromq"
  depends_on "zurl"

  fails_with gcc: "5"

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

    runfile.write <<~EOS
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
    EOS

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = fork do
      exec bin/"pushpin", "--config=#{conffile}"
    end

    begin
      system Formula["python@3.12"].opt_bin/"python3.12", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
