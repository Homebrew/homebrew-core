class Elasticsearch < Formula
  desc "Distributed search & analytics engine"
  homepage "https://www.elastic.co/products/elasticsearch"
  url "https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.0/elasticsearch-2.4.0.tar.gz"
  sha256 "3ae01140ae7bcbb91436feef381fbed774e36ef6d1e8e6a3153640db82acf4c9"

  devel do
    url "https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/5.0.0-alpha5/elasticsearch-5.0.0-alpha5.tar.gz"
    sha256 "4ec8fa57310affa9e0510aa18fb98c8b08f7e7d6f591d29c3e1fffe88d411813"
    version "5.0.0-alpha5"
  end

  head do
    url "https://github.com/elasticsearch/elasticsearch.git"
    depends_on :java => "1.8"
    depends_on "gradle" => :build
  end

  bottle :unneeded

  depends_on :java => "1.7+"

  def cluster_name
    "elasticsearch_#{ENV["USER"]}"
  end

  def install
    if build.head?
      # Build the package from source
      system "gradle", "clean", ":distribution:tar:assemble"
      # Extract the package to the tar directory
      mkdir "tar"
      cd "tar"
      system "tar", "--strip-components=1", "-xf", Dir["../distribution/tar/build/distributions/elasticsearch-*.tar.gz"].first
    end

    # Remove Windows files
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Install everything else into package directory
    libexec.install "bin", "config", "lib", "modules"

    # Set up Elasticsearch for local development:
    inreplace "#{libexec}/config/elasticsearch.yml" do |s|
      # 1. Give the cluster a unique name
      s.gsub!(/#\s*cluster\.name\: .*/, "cluster.name: #{cluster_name}")

      # 2. Configure paths
      s.sub!(%r{#\s*path\.data: /path/to.+$}, "path.data: #{var}/elasticsearch/")
      s.sub!(%r{#\s*path\.logs: /path/to.+$}, "path.logs: #{var}/log/elasticsearch/")
    end

    inreplace "#{libexec}/bin/elasticsearch.in.sh" do |s|
      # Configure ES_HOME
      if build.devel? || build.head?
        s.sub!(%r{#\!/bin/bash\n}, "#!/bin/bash\n\nES_HOME=#{libexec}")
      else
        s.sub!(%r{#\!/bin/sh\n}, "#!/bin/sh\n\nES_HOME=#{libexec}")
      end
    end

    plugin=(build.devel? || build.head?) ? "#{libexec}/bin/elasticsearch-plugin" : "#{libexec}/bin/plugin"
    inreplace plugin do |s|
      # Add the proper ES_CLASSPATH configuration
      s.sub!(/SCRIPT="\$0"/, %(SCRIPT="$0"\nES_CLASSPATH=#{libexec}/lib))
      # Replace paths to use libexec instead of lib
      s.gsub!(%r{\$ES_HOME/lib/}, "$ES_CLASSPATH/")
    end

    # Move config files into etc
    (etc/"elasticsearch").install Dir[libexec/"config/*"]
    (etc/"elasticsearch/scripts").mkdir unless File.exist?(etc/"elasticsearch/scripts")
    (libexec/"config").rmtree

    bin.write_exec_script Dir[libexec/"bin/elasticsearch"]
    if build.devel? || build.head?
      bin.write_exec_script Dir[libexec/"bin/elasticsearch-plugin"]
    end
  end

  def post_install
    # Make sure runtime directories exist
    (var/"elasticsearch/#{cluster_name}").mkpath
    (var/"log/elasticsearch").mkpath
    ln_s etc/"elasticsearch", libexec/"config"
    (libexec/"plugins").mkdir
  end

  def caveats
    s = <<-EOS.undent
      Data:    #{var}/elasticsearch/#{cluster_name}/
      Logs:    #{var}/log/elasticsearch/#{cluster_name}.log
      Plugins: #{libexec}/plugins/
      Config:  #{etc}/elasticsearch/
    EOS

    if stable?
      s += <<-EOS.undent
        plugin script: #{libexec}/bin/plugin
      EOS
    end

    s
  end

  plist_options :manual => "elasticsearch"

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{HOMEBREW_PREFIX}/bin/elasticsearch</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/elasticsearch.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/elasticsearch.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    if devel? || head?
      system "#{libexec}/bin/elasticsearch-plugin", "list"
    else
      system "#{libexec}/bin/plugin", "list"
    end
    pid = "#{testpath}/pid"
    begin
      if devel? || head?
        system "#{bin}/elasticsearch", "-d", "-p", pid, "-Epath.data=#{testpath}/data"
      else
        system "#{bin}/elasticsearch", "-d", "-p", pid, "--path.data", testpath/"data"
      end
      sleep 10
      system "curl", "-XGET", "localhost:9200/"
    ensure
      Process.kill(9, File.read(pid).to_i)
    end
  end
end
