class Pushpin < Formula
  desc "Reverse proxy for realtime web services"
  homepage "http://pushpin.org"
  url "https://dl.bintray.com/fanout/source/pushpin-1.10.0.tar.bz2"
  sha256 "8823b51bc7edb2b595e7f5ad0cefc14d1fdb59fd75ff46aea6efb479a9ca1c38"

  head "https://github.com/fanout/pushpin.git"

  bottle do
    sha256 "a9524472472825a142f1a5086ec5ce076411ddb0d043782253bdac04d675c6fe" => :el_capitan
    sha256 "8bdc03848cacc6b1b8cdf093a7e559691071644be61dcf84c1cfb79a73563190" => :yosemite
    sha256 "fa3468dafa0c55353b7ef24faabf046a23f62e768616eb883228b5dfa2139063" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "qt5"
  depends_on "zeromq"
  depends_on "mongrel2"
  depends_on "zurl"

  # MacOS versions prior to Yosemite need the latest setuptools in order to compile dependencies
  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-19.4.tar.gz"
    sha256 "214bf29933f47cf25e6faa569f710731728a07a19cae91ea64f826051f68a8cf"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "setproctitle" do
    url "https://pypi.python.org/packages/source/s/setproctitle/setproctitle-1.1.9.tar.gz"
    sha256 "1c3414d18f9cacdab78b0ffd8e886d56ad45f22e55001a72aaa0b2aeb56a0ad7"
  end

  resource "pyzmq" do
    url "https://pypi.python.org/packages/source/p/pyzmq/pyzmq-15.2.0.tar.gz"
    sha256 "2dafa322670a94e20283aba2a44b92134d425bd326419b68ad4db8d0831a26ec"
  end

  resource "tnetstring" do
    url "https://pypi.python.org/packages/source/t/tnetstring/tnetstring-0.2.1.tar.gz"
    sha256 "55715a5d758214034db179005def47ed842da36c4c48e9e7ae59bcaffed7ca9b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    %w[setuptools MarkupSafe Jinja2 setproctitle].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "./configure", "--prefix=#{prefix}", "--configdir=#{etc}", "--rundir=#{var}/run", "--logdir=#{var}/log", "--extraconf=QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    system "make"
    system "make", "check"
    system "make", "install"

    pyenv = { :PYTHONPATH => ENV["PYTHONPATH"] }
    %w[pushpin].each do |f|
      (libexec/"bin").install bin/f
      (bin/f).write_env_script libexec/"bin/#{f}", pyenv
    end
  end

  test do
    conffile = testpath/"pushpin.conf"
    routesfile = testpath/"routes"
    runfile = testpath/"test.py"

    cp HOMEBREW_PREFIX/"etc/pushpin/pushpin.conf", conffile
    cp HOMEBREW_PREFIX/"etc/pushpin/routes", routesfile

    %w[pyzmq tnetstring].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(testpath/"vendor")
      end
    end

    inreplace conffile do |s|
      s.gsub! "rundir=#{HOMEBREW_PREFIX}/var/run/pushpin", "rundir=#{testpath}/var/run/pushpin"
      s.gsub! "logdir=#{HOMEBREW_PREFIX}/var/log/pushpin", "logdir=#{testpath}/var/log/pushpin"
    end
    inreplace routesfile, "test", "localhost:10080"

    runfile.write <<-EOS.undent
      import urllib2
      import threading
      from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
      class TestHandler(BaseHTTPRequestHandler):
        def do_GET(self):
          self.send_response(200)
          self.end_headers()
          self.wfile.write('test response\\n')
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
      f = urllib2.urlopen('http://localhost:7999/test')
      body = f.read()
      assert(body == 'test response\\n')
    EOS

    pid = fork do
      exec "#{bin}/pushpin", "--config=#{conffile}"
    end

    begin
      sleep 3 # make sure pushpin processes have started
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      ENV.prepend_create_path "PYTHONPATH", testpath/"vendor/lib/python2.7/site-packages"
      system "python", runfile
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
