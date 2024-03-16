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
    sha256 cellar: :any,                 sonoma:       "ace5ffa91826756133c944eb86bd0cc93f60d5143fd054966ad6a960c2ad02b8"
    sha256 cellar: :any,                 ventura:      "e03f4034571cf0ecb9f3ca5273581b6092bdbc4b8db6c59df6bd06682c1b2c17"
    sha256 cellar: :any,                 monterey:     "fe0a1365ca2bf4893497e94a821eae6f757576415f11cb739ffbad4a865624e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "02a03ff705aa26e807f3de0f58e7c221eb8243091a0d0c680626bb750f8dead4"
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
