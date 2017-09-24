class Metricbeat < Formula
  desc "Collect metrics from your systems and services."
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v5.6.1.tar.gz"
  sha256 "3534ef7a3833ae85aef53a12580520b5d85feaa1408289ea37a6ebff5a2fda0a"

  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 "c98c75722f3c549da246dde9f83cefe03af9ca95ac4227a464514790c8d77d8d" => :high_sierra
    sha256 "21886e9519ed8ae453795d2a9c80afada7f1eca1701771833eba338368865c42" => :sierra
    sha256 "b7359323c3c70e01996f26ef05dd2e1e8612264431a2b71d652fdc92cac4ef58" => :el_capitan
  end

  depends_on "go" => :build

  def install
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/elastic/beats").install Dir["{*,.git,.gitignore}"]

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/elastic/beats/metricbeat" do
      system "make"
      libexec.install "metricbeat"

      (etc/"metricbeat").install "metricbeat.full.yml"
      (etc/"metricbeat").install "metricbeat.yml"
      (etc/"metricbeat").install "metricbeat.template.json"
      (etc/"metricbeat").install "metricbeat.template-es2x.json"
      (etc/"metricbeat").install "metricbeat.template-es6x.json"
    end

    (bin/"metricbeat").write <<-EOS.undent
      #!/bin/sh
      exec "#{libexec}/metricbeat" --path.config "#{etc}/metricbeat" --path.home="#{prefix}" --path.logs="#{var}/log/metricbeat" --path.data="#{opt_prefix}" "$@"
    EOS
  end

  plist_options :manual => "metricbeat"

  def plist; <<-EOS.undent
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
    (testpath/"metricbeat.yml").write <<-EOS.undent
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

    metricbeat_pid = fork do
      exec bin/"metricbeat", "-c", testpath/"metricbeat.yml",
      "--path.data=#{testpath}/data", "--path.logs=#{testpath}/logs"
    end

    begin
      sleep 2
      assert File.exist? testpath/"data/metricbeat"
    ensure
      Process.kill("TERM", metricbeat_pid)
    end
  end
end
