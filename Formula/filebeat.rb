class Filebeat < Formula
  desc "File harvester, used to fetch logs files and feed them into logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats/archive/v1.2.3.tar.gz"
  sha256 "8eea85de415898c362144ba533062651d8891241c738799e54cc9b17040c1fc9"

  head "https://github.com/elastic/beats.git"

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/filebeat" do
      system "make"
      libexec.install "filebeat"
      etc.install "etc/filebeat.yml"
    end

    (bin/"filebeat").write <<-EOS.undent
      #!/bin/sh
      exec "#{libexec}/filebeat" -c "#{etc}/filebeat.yml" "$@"
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
    log_file = testpath/"log"
    touch log_file

    (testpath/"filebeat.yml").write <<-EOS.undent
      filebeat:
        prospectors:
          -
            paths:
              - #{log_file}
            scan_frequency: 0s
      output:
        file:
          path: #{testpath}
    EOS

    filebeat_pid = fork { exec bin/"filebeat", "-c", testpath/"filebeat.yml" }
    sleep 5
    log_file.append_lines "foo bar baz"
    sleep 10

    begin
      assert File.exist? testpath/"filebeat"
    ensure
      Process.kill("TERM", filebeat_pid)
    end
  end
end
