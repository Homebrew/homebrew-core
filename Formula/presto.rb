class Presto < Formula
  desc "Distributed SQL query engine for big data"
  homepage "https://prestodb.io"
  url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.165/presto-server-0.165.tar.gz"
  sha256 "a22a1d912b11755cf8353f3c714740b7bf04237beaf171689ef20ab0590696d8"

  bottle :unneeded

  depends_on :java => "1.8+"

  cli_version = version
  resource "presto-cli" do
    version cli_version
    url "https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-cli/#{version}/presto-cli-#{version}-executable.jar"
    sha256 "8b831133ceff433ad7c0e42eea8411baa47e52caceef86e6ee976c70fc68343a"
  end

  def install
    libexec.install Dir["*"]

    (libexec/"etc/node.properties").write <<-EOS.undent
      node.environment=production
      node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
      node.data-dir=#{var}/presto/data
    EOS

    (libexec/"etc/jvm.config").write <<-EOS.undent
      -server
      -Xmx16G
      -XX:+UseG1GC
      -XX:G1HeapRegionSize=32M
      -XX:+UseGCOverheadLimit
      -XX:+ExplicitGCInvokesConcurrent
      -XX:+HeapDumpOnOutOfMemoryError
      -XX:OnOutOfMemoryError=kill -9 %p
    EOS

    (libexec/"etc/config.properties").write <<-EOS.undent
      coordinator=true
      node-scheduler.include-coordinator=true
      http-server.http.port=8080
      query.max-memory=5GB
      query.max-memory-per-node=1GB
      discovery-server.enabled=true
      discovery.uri=http://localhost:8080
    EOS

    (libexec/"etc/log.properties").write "com.facebook.presto=INFO"

    (libexec/"etc/catalog/jmx.properties").write "connector.name=jmx"

    (bin/"presto-server").write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/launcher" "$@"
    EOS

    resource("presto-cli").stage do
      bin.install "presto-cli-#{version}-executable.jar" => "presto"
    end
  end

  def post_install
    (var/"presto/data").mkpath
  end

  def caveats; <<-EOS.undent
    Add connectors to #{libexec}/etc/catalog/. See:
    https://prestodb.io/docs/current/connector.html
    EOS
  end

  plist_options :manual => "presto-server run"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>AbandonProcessGroup</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{opt_libexec}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/presto-server</string>
          <string>run</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"presto-server", "run", "--help"
  end
end
