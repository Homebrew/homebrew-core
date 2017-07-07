class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats/archive/v5.5.0.tar.gz"
  sha256 "3f826ce614b6caef12a5584d3c97a4496222a70b02b818b3ec5bb08dc3aa6994"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15e30c52813543f4d007db8d18edfd5383f0b31001914f31dafdebb17061f2eb" => :sierra
    sha256 "ace009775c3fb053360275fba3976859a9c25f51624ad25f56a6bdd1450ebc47" => :el_capitan
    sha256 "957fc3fc0e8871aae71e623b8db02cc6cb7cf621df4f7c3227266a6274056c18" => :yosemite
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
