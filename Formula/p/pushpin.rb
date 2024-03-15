class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "https://pushpin.org/"
  license "Apache-2.0"
  head "https://github.com/fastly/pushpin.git", branch: "main"

  stable do
    url "https://github.com/fastly/pushpin/releases/download/v1.39.0/pushpin-1.39.0.tar.bz2"
    sha256 "25044e1f1dabdbd20fd42d35666f4b4a0e84bae2146dd30c8f82c85543a97bf2"

    patch do
      url "https://github.com/fastly/pushpin/commit/b20aeed32fa0d7eb7cd47119608c0208d0373513.patch?full_index=1"
      sha256 "bb7e181a0ed35e67d784b658658bbceb9f3c6b108e027431dd1e1798b2c5a0e3"
    end
    patch do
      url "https://github.com/fastly/pushpin/commit/8b17bf4b59731af62a9508b1143d72f6615cef7d.patch?full_index=1"
      sha256 "32bd7cb01251d4a365ecf83c7e76b27a47dfca2a84aeecd11d9d5ede398af293"
    end
  end

  bottle do
    sha256 cellar: :any,                 sonoma:       "81f2c6e156315aef82f7e0fc11b1aabb44ef025bed358ede917a10c8f4655cbe"
    sha256 cellar: :any,                 ventura:      "92354afd447abc7fd4e59d9237d99240ca9e79ef75640e0d42675f6b132e8a8c"
    sha256 cellar: :any,                 monterey:     "5627e0fc4a44217389727c56cdb34739778dd246e7ee4438215f0359ad2bf3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24069e84ab4746114b10d4052c7920370e75515a1385cd96b5e1a3ed6c20e575"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "mongrel2"
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

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      system Formula["python@3.12"].opt_bin/"python3.12", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
