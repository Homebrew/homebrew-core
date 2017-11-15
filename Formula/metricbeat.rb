class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v6.0.0.tar.gz"
  sha256 "c4a8130934eb132f637e0a76ed4d764b92e7ed469abc97587a3625a61668744e"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffec3156e5fbe019cc14bf4a178abffdd395584f6003ddbb10839d05959f3ea0" => :high_sierra
    sha256 "30663833a9af219adc9dcf423ff64ddddf80407508b64139fdc18d176053ebf4" => :sierra
    sha256 "314bc6aa68d317d98cf18780600d73e81cb441c1f60a26b0b71b76b3d55e8d94" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    cd "src/github.com/elastic/beats/metricbeat" do
      system "make"
      system "make", "kibana"
      (libexec/"bin").install "metricbeat"
      libexec.install "_meta/kibana"

      (etc/"metricbeat").install Dir["metricbeat*.yml"]
      prefix.install_metafiles
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec "#{libexec}/bin/metricbeat" \
        --path.config "#{etc}/metricbeat" \
        --path.home="#{prefix}" \
        --path.logs="#{var}/log/metricbeat" \
        --path.data="#{var}/lib/metricbeat" \
        "$@"
    EOS
  end

  plist_options :manual => "metricbeat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/metricbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    begin
      sleep 30
      assert_predicate testpath/"data/metricbeat", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
