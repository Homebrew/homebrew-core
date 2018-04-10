class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/products/beats/metricbeat"
  url "https://github.com/elastic/beats/archive/v6.2.3.tar.gz"
  sha256 "4ab58a55e61bd3ad31a597e5b02602b52d306d8ee1e4d4d8ff7662e2b554130e"

  head "https://github.com/elastic/beats.git"

  # Can be removed when support for compilation under go 1.9.4 is supported,
  # potentially planned for the 6.2.3 release.
  # Related upstream PRs:
  # - https://github.com/elastic/beats/pull/6388
  # - https://github.com/elastic/beats/pull/6326
  patch :DATA

  bottle do
    cellar :any_skip_relocation
    sha256 "15e66dea9b402894a072b4095f0654501eb860c29d1c2c80f3930b8a46dcaba5" => :high_sierra
    sha256 "d578b893239bc7315fbd73872207240f02c8ffe585f4d4a8c5155346128275aa" => :sierra
    sha256 "1d03d2d51ef01382deabd9f1dc0969b3f43a0884a38182c4b73c65c04304100a" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "python@2" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b1/72/2d70c5a1de409ceb3a27ff2ec007ecdd5cc52239e7c74990e32af57affe9/virtualenv-15.2.0.tar.gz"
    sha256 "1d7e241b431e7afce47e77f8843a276f652699d1fa4f93b9d8ce0076fd7b0b54"
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

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "_meta/kibana"
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
