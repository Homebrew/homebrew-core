class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.10.1",
      revision: "1da173a9e716715a7a54bb3ff4db05b5c24fc8ce"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8b70d41e9f356b77f8499e142bd6d64f9252d6777ea78a2071147687163e719" => :big_sur
    sha256 "85c21c85871154bf167fd82a130ffa89a1163b1714e94ade2af3b4569ed5f90d" => :catalina
    sha256 "17bc52c02530e33e4a4fdc4f5b89d7690c95c0d3475e47bfeb557fd4c0ebbc5b" => :mojave
    sha256 "878565910ac7e3d43a3457482fd39accbd1da6a7afb0dbb6d3f3bb6a99c58126" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "python@3.9" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children
    ENV.prepend_path "PATH", buildpath/"bin" # for mage (build tool)

    cd "src/github.com/elastic/beats/metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "make", "mage"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS
  end

  plist_options manual: "metricbeat"

  def plist
    <<~EOS
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

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 30
    assert_predicate testpath/"data/metricbeat", :exist?
  end
end
