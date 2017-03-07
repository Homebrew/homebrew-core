class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats/archive/v5.2.2.tar.gz"
  sha256 "45c89fab339de3d3e7f9a83c7a48312ede147d5989b67b8619d9128353c891c3"

  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 "77b72c2af484dc5ce409757e62083fd8ff60872ac280f71e8c00e8cb9c261d24" => :sierra
    sha256 "0d4fe922c914391ae9d4b07f63be10232b9bf9e85c12fba9e09619961ae0bd6e" => :el_capitan
    sha256 "1ed699f8aad1f2743c32acbde472b7d30068b7bbe19fcd6d9397d881b2b98115" => :yosemite
  end

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/packetbeat" do
      system "make"
      libexec.install "packetbeat"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install("packetbeat.yml", "packetbeat.template.json", "packetbeat.template-es2x.json")
    end

    (bin/"packetbeat").write <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/packetbeat -path.config #{etc}/packetbeat \
        -path.home #{prefix} -path.logs #{var}/log/packetbeat \
        -path.data #{var}/packetbeat $@
    EOS
  end

  plist_options :manual => "packetbeat"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/packetbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/packetbeat", "--devices"
  end
end
