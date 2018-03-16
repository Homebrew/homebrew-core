class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v6.2.2.tar.gz"
  sha256 "0866c3e26fcbd55f191e746b3bf925b450badd13fb72ea9f712481559932c878"

  head "https://github.com/elastic/beats.git"

  # Can be removed when support for compilation under go 1.9.4 is supported,
  # potentially planned for the 6.2.3 release.
  # Related upstream PRs:
  # - https://github.com/elastic/beats/pull/6388
  # - https://github.com/elastic/beats/pull/6326
  patch :DATA

  bottle do
    cellar :any_skip_relocation
    sha256 "c04e96878a0a0170f5e3d95a67cca6d5c298fdda435483edcb7b756782989406" => :high_sierra
    sha256 "9d1236c5afefd8d12d698cca1b0dcd9850c057377bbc3f27ce82b8b6437f79ab" => :sierra
    sha256 "0b038131e12c6ad912b3ea4e808fa573830e570b4967c6dfaf591fb889ca4be4" => :el_capitan
  end

  depends_on "go" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("virtualenv").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    cd "src/github.com/elastic/beats/metricbeat" do
      system "make"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_COMMANDS=--no-binary :all", "python-env"
      system "make", "DEV_OS=darwin", "update"
      system "make", "kibana"
      (libexec/"bin").install "metricbeat"
      libexec.install "_meta/kibana"

      (etc/"metricbeat").install Dir["metricbeat*.yml", "fields.yml"]
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

__END__
diff --git a/vendor/github.com/shirou/gopsutil/disk/disk_darwin_cgo.go b/vendor/github.com/shirou/gopsutil/disk/disk_darwin_cgo.go
index 2f5e22b64e..210779786b 100644
--- a/vendor/github.com/shirou/gopsutil/disk/disk_darwin_cgo.go
+++ b/vendor/github.com/shirou/gopsutil/disk/disk_darwin_cgo.go
@@ -5,7 +5,7 @@ package disk

 /*
 #cgo CFLAGS: -mmacosx-version-min=10.10 -DMACOSX_DEPLOYMENT_TARGET=10.10
-#cgo LDFLAGS: -mmacosx-version-min=10.10 -lobjc -framework Foundation -framework IOKit
+#cgo LDFLAGS: -lobjc -framework Foundation -framework IOKit
 #include <stdint.h>

 // ### enough?
