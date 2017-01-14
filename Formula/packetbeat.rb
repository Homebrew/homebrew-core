class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats/archive/v5.1.2.tar.gz"
  sha256 "7cd554f8be6b02290ebbc17c9820acde3dc59108672ced7a0cf5486faa3e23ce"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fb69cb1fee6b18e4730d5192b6d8d8cc77b176966d579a2a242bd840aa677bf" => :sierra
    sha256 "8af84527b2c08f22b4cf952586251788e5e4528eca68a78435a690284661d25c" => :el_capitan
    sha256 "75df0ef86971ce26ac40258d6e91adc5279329259ff9b1d9ead19e2280ba8cfa" => :yosemite
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
