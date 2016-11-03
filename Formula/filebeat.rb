class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats/archive/v5.0.0.tar.gz"
  sha256 "3e6b7cf2ee5f52e78ae87ef04ab9dd49977c89f86a09416586896aeaea844e34"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9972b76802297bd33ef53ac79b8b3494efdc773d40759ec0196a7abceec2a784" => :sierra
    sha256 "5dd2ec94fc5af84b47188c413ec4c414b3f3614ff2a07d4e28fcf719aab5b4e2" => :el_capitan
    sha256 "32f634750427dc51ccf70aa805b9b3819a7cf47cf00f829c511e169ab916562b" => :yosemite
    sha256 "7507367228a95cbcb2b9b8373f352c6996a5b929737290e4b75fba5dc02c8c54" => :mavericks
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
