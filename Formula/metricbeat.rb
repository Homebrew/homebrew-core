class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v6.0.0.tar.gz"
  sha256 "c4a8130934eb132f637e0a76ed4d764b92e7ed469abc97587a3625a61668744e"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12127b447d1a6fd6a98aaa458dd4b137b9f3d1b1947796d496e154193a862a5b" => :high_sierra
    sha256 "2a316d2c7eec66eb4814d52ba1b270501b81d988c8df8bb8d8024a0a6df3a933" => :sierra
    sha256 "f0f3e2cfa6e5b40172e069985ab0cad8fe1eb7ea63b9c9fb321f6d6463488942" => :el_capitan
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
