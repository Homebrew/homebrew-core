class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats/archive/v5.3.0.tar.gz"
  sha256 "311030e33ec6f5f335ddf9e0b8eb3a1cd9e378dbc7c0937658a02099457c5895"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dd5a450dafc589d15e4874e5503bc66e8ebf5000c65b94f1df1ca482c2626d4" => :sierra
    sha256 "98f17198bd8bbae07b8f9dc73029c78d86f67c8eca9205331bef9d70ee82d6fc" => :el_capitan
    sha256 "e0449c354a944630a86a844bd9ff7b206cea4e38eac691b1be2b37e38f5e35fc" => :yosemite
  end

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/filebeat" do
      system "make"
      libexec.install "filebeat"

      (etc/"filebeat").install("filebeat.yml", "filebeat.template.json", "filebeat.template-es2x.json")
    end

    prefix.install_metafiles gopath/"src/github.com/elastic/beats"

    (bin/"filebeat").write <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/filebeat -path.config #{etc}/filebeat -path.home #{prefix} -path.logs #{var}/log/filebeat -path.data #{var}/filebeat $@
    EOS
  end

  plist_options :manual => "filebeat"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/filebeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    log_file = testpath/"test.log"
    touch log_file

    (testpath/"filebeat.yml").write <<-EOS.undent
      filebeat:
        prospectors:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
      filebeat.idle_timeout: 0.1s
      output:
        file:
          path: #{testpath}
    EOS

    (testpath/"log").mkpath
    (testpath/"data").mkpath

    filebeat_pid = fork { exec "#{bin}/filebeat -c #{testpath}/filebeat.yml -path.config #{testpath}/filebeat -path.home=#{testpath} -path.logs #{testpath}/log -path.data #{testpath}" }
    begin
      sleep 1
      log_file.append_lines "foo bar baz"
      sleep 5

      assert File.exist? testpath/"filebeat"
    ensure
      Process.kill("TERM", filebeat_pid)
    end
  end
end
