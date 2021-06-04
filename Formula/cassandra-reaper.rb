class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/2.2.5/cassandra-reaper-2.2.5-release.tar.gz"
  sha256 "5622555209e1d347f7c2173097a865a540d9ccd3a66222aa563e773d645cedbe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37f39d8bd30b6aa47004edcffbadb32dec037271f96cfd4b4fe6f2a63f902497"
  end

  depends_on arch: :x86_64 # openjdk@8 does not support ARM
  depends_on "openjdk@8"

  def install
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"
    inreplace Dir[etc/"cassandra-reaper/*.yaml"], " /var/log", " #{var}/log"
  end

  plist_options manual: "cassandra-reaper"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/cassandra-reaper</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/cassandra-reaper/service.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/cassandra-reaper/service.err</string>
          <key>EnvironmentVariables</key>
          <dict>
            <key>JAVA_HOME</key>
            <string>#{Formula["openjdk@8"].opt_prefix}</string>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix
    cp etc/"cassandra-reaper/cassandra-reaper.yaml", testpath
    port = free_port
    inreplace "cassandra-reaper.yaml" do |s|
      s.gsub! "port: 8080", "port: #{port}"
      s.gsub! "port: 8081", "port: #{free_port}"
    end
    fork do
      exec "#{bin}/cassandra-reaper", "#{testpath}/cassandra-reaper.yaml"
    end
    sleep 30
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
