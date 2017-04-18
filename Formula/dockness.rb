require "language/go"
require "timeout"

class Dockness < Formula
  desc "DNS for Docker machines"
  homepage "https://github.com/bamarni/dockness"
  url "https://github.com/bamarni/dockness.git",
      :tag => "v2.0.1",
      :revision => "70d968325711e1fc3eecfbbf35cebf6be9a18a98"

  head "https://github.com/bamarni/dockness.git"

  depends_on "go" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git",
    :revision => "ae9f392c10807c0a0792bc1821b3746570095be2"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
    :revision => "c9d1302d540edfb97d9ecbfe90b4fb515088630b"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dockness"
  end

  def caveats; <<-EOS.undent
    Note: When using launchctl the top level domain will be
    "docker" and the listening port will be 10053.

    To make a top level domain called "docker" resolve properly,
    add a file called /etc/resolver/docker as root with the
    following contents:

      nameserver 127.0.0.1
      port 10053

    The name of the top level domain and port can be changed by
    modifying changing the -tld and -port arguments in the
    launchctl plist file.
    EOS
  end

  plist_options :manual => "dockness -port 10053 -tld docker"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Disabled</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/dockness</string>
        <string>-port</string>
        <string>10053</string>
        <string>-tld</string>
        <string>docker</string>
        <string>-debug</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    # pick random port
    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]

    pid = Process.spawn("#{bin}/dockness -port #{port}")
    begin
      Timeout.timeout(1) do
        Process.wait(pid)
        raise "dockness failed to start listening on port #{port}"
      end
    rescue Timeout::Error
      Process.kill("KILL", pid)
      # Timeout means success; lack of timeout means that it could not start
    end
  end
end
