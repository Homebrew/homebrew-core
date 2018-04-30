class NginxUnit < Formula
  desc "Dynamic web and application server for multiple languages"
  homepage "https://unit.nginx.org/"
  url "https://unit.nginx.org/download/unit-1.1.tar.gz"
  sha256 "7c66365f5ea87e7e8903bac9d639676947fe2ab7aa799ce35defc426b3409ee0"

  depends_on "openssl"
  depends_on "pcre"

  def install
    openssl = Formula["openssl"]
    pcre = Formula["pcre"]

    system "./configure",
      "--prefix=#{prefix}",
      "--bindir=#{bin}",
      "--sbindir=#{bin}",
      # This tells the unit daemon where it can load modules from. Configuring
      # the location at runtime is painful. We want this to be in the
      # $HOMEBREW_PREFIX so that other formulae can link in additional modules. 
      "--modules=#{HOMEBREW_PREFIX/"lib/unit"}",
      "--state=#{var/"unit"}",
      "--log=#{var/"log/unit.log"}",
      "--pid=#{var/"run/unit.pid"}",
      "--control=unix:#{var/"run/unit.control.sock"}",
      "--cc-opt=-I#{pcre.opt_include} -I#{openssl.opt_include}",
      "--ld-opt=-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

    system "make", "install"

    # Beyond here we want to install modules into the keg, so we'll move them
    # into the prefix ourselves
    libunit = lib/"unit"
    libunit.mkpath

    # There is no system Go
    #system "./configure", "go"
    #system "make", "go"
    #libunit.install "build/go.unit.so"

    system "./configure", "perl"
    system "make", "perl"
    libunit.install "build/perl.unit.so"

    # We can't build against the system PHP, it doesn't have the right SAPI
    #system "./configure", "php"
    #system "make", "php"
    #libunit.install "build/php.unit.so"

    system "./configure", "python"
    system "make", "python"
    libunit.install "build/python.unit.so"

    system "./configure", "ruby"
    system "make", "ruby"
    libunit.install "build/ruby.unit.so"
  end

  def caveats
    <<~EOS
      Once running, you can control unit using the control socket, for example using curl:
        curl --unix-socket #{var}/run/unit.control.sock http://localhost/

      Modules are available for system perl, python and ruby. The system php doesn't support nginx-unit. You can install additional modules into:
        #{HOMEBREW_PREFIX/"lib/unit"}
    EOS
  end

  plist_options :manual => "unitd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/unitd</string>
            <string>--no-daemon</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/unitd", "--version"

    require "json"
    require "net/http"
    require "socket"
    require "timeout"

    logfile = var/"log/unit.log"
    logfile.unlink if logfile.exist?

    pidfile = var/"run/unit.pid"
    pidfile.unlink if pidfile.exist?

    begin
      # We need to install rack for the ruby module test to work, so set a
      # temporary gems path before booting unitd. (unitd boots and functions
      # fine without, but fails to start an app until rack is installed.)
      rubydir = testpath/"ruby"
      rubygems = rubydir/"gems"
      rubygems.mkpath
      ENV["GEM_PATH"] = rubygems.to_s
      system "gem", "install", "rack", "--install-dir=#{rubygems}", "--verbose"

      pid = spawn "#{bin}/unitd", "--no-daemon"

      timeout(5) { sleep 0.1 until pidfile.exist? }

      assert_equal pid, pidfile.read.chomp.to_i

      timeout(5) { sleep 0.1 until File.exist? var/"run/unit.control.sock" }

      # Unit uses a unix control socket. Net::HTTP to a socket is hard. Sorry.
      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Get.new("/")
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      assert_equal("200", response.code)
      expected_body = {"listeners" => {}, "applications" => {}}
      assert_equal expected_body, JSON.parse(response.body)

      assert logfile.size > 0

      # Unit should discover each of the modules and talk about them in the log
      logfile.read.tap do |logs|
        #assert_include logs, "lib/unit/go.unit.so"
        assert_include logs, "lib/unit/perl.unit.so"
        #assert_include logs, "lib/unit/php.unit.so"
        assert_include logs, "lib/unit/python.unit.so"
        assert_include logs, "lib/unit/ruby.unit.so"
      end

      ### Perl module

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({})
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      perldir = testpath/"perl"
      perldir.mkpath
      perlapp = perldir/"app.psgi"

      perlapp.write <<~PERL
        my $app = sub {
          my $env = shift;
          return [ '200', [ 'Content-Type' => 'text/plain' ], [ "Hello, perl world!" ] ];
        }
      PERL

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({
        "listeners" => {"*:8000" => {"application" => "perlapp"}},
        "applications" => {"perlapp" => {"type" => "perl", "working_directory" => perldir, "script" => perlapp.to_s}},
      })
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      assert_equal "200", response.code
      expected_body = {"success" => "Reconfiguration done."}
      assert_equal expected_body, JSON.parse(response.body)

      response = Net::HTTP.get_response(URI.parse("http://localhost:8000"))
      assert_equal "200", response.code
      assert_equal "Hello, perl world!", response.body

      ### Python module

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({})
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      pythondir = testpath/"python"
      pythondir.mkpath
      pythonapp = pythondir/"wsgi.py"

      pythonapp.write <<~PYTHON
        def application(environ, start_response):
          start_response('200 OK', [('Content-Type', 'text/plain')])
          return ["Hello, python world!"]
      PYTHON

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({
        "listeners" => {"*:8000" => {"application" => "pythonapp"}},
        "applications" => {"pythonapp" => {"type" => "python", "path" => pythondir.to_s, "module" => "wsgi"}},
      })
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      assert_equal "200", response.code
      expected_body = {"success" => "Reconfiguration done."}
      assert_equal expected_body, JSON.parse(response.body)

      response = Net::HTTP.get_response(URI.parse("http://localhost:8000"))
      assert_equal "200", response.code
      assert_equal "Hello, python world!", response.body

      ### Ruby module

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({})
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      rubydir.mkpath
      rubyapp = rubydir/"config.ru"

      rubyapp.write <<~RUBY
        run lambda { |env| [200, {"Content-Type" => "text/plain"}, ["Hello, ruby world!"]]}
      RUBY

      socket = Net::BufferedIO.new(UNIXSocket.new(var/"run/unit.control.sock"))
      request = Net::HTTP::Put.new("/config")
      request.body = JSON.generate({
        "listeners" => {"*:8000" => {"application" => "rubyapp"}},
        "applications" => {"rubyapp" => {"type" => "ruby", "working_directory" => rubydir, "script" => rubyapp.to_s}},
      })
      request.exec(socket, "1.1", request.path)
      response = Net::HTTPResponse.read_new(socket)
      response.reading_body(socket, request.response_body_permitted?) { }

      assert_equal "200", response.code
      expected_body = {"success" => "Reconfiguration done."}
      assert_equal expected_body, JSON.parse(response.body)

      response = Net::HTTP.get_response(URI.parse("http://localhost:8000"))
      assert_equal "200", response.code
      assert_equal "Hello, ruby world!", response.body
    rescue
      oh1 "unit.log"
      print logfile.read if logfile.exist?
      raise
    ensure
      if pid
        Process.kill "SIGINT", pid
        Process.wait pid
      end
    end
  end
end
