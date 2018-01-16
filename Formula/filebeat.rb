class Filebeat < Formula
  desc "File harvester to ship log files to Elasticsearch or Logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats/archive/v6.1.2.tar.gz"
  sha256 "e673b4f03bc73807d23083b8d6a5f45f5a8b3fa3a6709f89881a2debb10a8d2f"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b591db4508a251ae2f53db7f3f0f2ad0febf9520ed851aa5e5084b5f56f0b941" => :high_sierra
    sha256 "bfa3d9a81dc31b9f79c64e9bb29ff0bc26c3d5082ee8540cbc5a735a0d1531fb" => :sierra
    sha256 "643b99d29e78947269b9140b4956ee713cb7713aa7caea4820dd6c14924a99d6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/filebeat" do
      system "make"
      system "make", "modules"
      libexec.install "filebeat"
      (prefix/"module").install Dir["_meta/module.generated/*"]
      (etc/"filebeat").install Dir["filebeat.*"]
    end

    prefix.install_metafiles gopath/"src/github.com/elastic/beats"

    (bin/"filebeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/filebeat -path.config #{etc}/filebeat -path.home #{prefix} -path.logs #{var}/log/filebeat -path.data #{var}/filebeat $@
    EOS
  end

  plist_options :manual => "filebeat"

  def plist; <<~EOS
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

    (testpath/"filebeat.yml").write <<~EOS
      filebeat:
        prospectors:
          -
            paths:
              - #{log_file}
            scan_frequency: 0.1s
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

      assert_predicate testpath/"filebeat", :exist?
    ensure
      Process.kill("TERM", filebeat_pid)
    end
  end
end
