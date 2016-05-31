class Filebeat < Formula
  desc "File harvester, used to fetch logs files and feed them into logstash"
  homepage "https://www.elastic.co/products/beats/filebeat"
  url "https://github.com/elastic/beats.git",
    :tag => "v1.2.3",
    :revision => "e849e45f713a6112145ac8309fc23bd69bc41ef8"

  head "https://github.com/elastic/beats.git"

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/filebeat" do
      system "go", "get"
      system "make"
      libexec.install "filebeat"
      etc.install "etc/filebeat.yml"
    end

    sh = bin/"filebeat"
    sh.write "#!/usr/bin/env bash\n\n#{libexec}/filebeat -c #{etc}/filebeat.yml \"$@\""
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
    system bin/"filebeat", "--version"
  end
end
