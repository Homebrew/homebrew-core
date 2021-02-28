class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/2.2.1/cassandra-reaper-2.2.1-release.tar.gz"
  sha256 "7c15268a33f6401969e24f714b50d65917273d08648d7b1b20e04ccbb820ce93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "30e21a4dbee1a86a8115715f99552b6f4bded64077f6b89bf5c34c3aae038532"
    sha256 cellar: :any_skip_relocation, catalina: "048e3ff4e561888460dc1f19fcb1dff4bedf96940dafb3b32ca52eb7d08cfd11"
    sha256 cellar: :any_skip_relocation, mojave:   "bc65e9035e8fb1665fb6bd08c817975d965feca6eed651a5fd24e93fbfd86602"
  end

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
    sleep 10
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
