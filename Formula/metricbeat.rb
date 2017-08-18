class Metricbeat < Formula
  desc "Collect metrics from your systems and services."
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v5.5.2.tar.gz"
  sha256 "39e792324a35fe84ef9a63cd5324252bc71d1c665188e8d597e12ca170cfde7a"

  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98c815837b561d241cee94e10dffd92d71914611a3801772b52d329f32f27299" => :sierra
    sha256 "efc3b8c7502818d18429fe161284f4872afa8f9a12361581eb32f01d9e92130a" => :el_capitan
    sha256 "e1e33c6006ae7dcca5ace97229e59ce880c8145223794d44c266b9315808a8c3" => :yosemite
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
