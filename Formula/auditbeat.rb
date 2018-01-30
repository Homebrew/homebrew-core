class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats/archive/v6.1.3.tar.gz"
  sha256 "5a21ce1eca7eab2b8214b54a7f4690cd557cd05073119f861025330e1b4006a3"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0bc7143d62bb50e0d38f131c9c6e1b9ebb272c308ff32e1b6be5a3474f4f32" => :high_sierra
    sha256 "bd2bbfa643a589b44b9ab23e7ca5fe851ebde65c5e33de51b74b971d407cdf9d" => :sierra
    sha256 "68277f6a36331f5768938e345303611caca7cd7ee40e4b35e44a1a3fd68f2791" => :el_capitan
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

    cd "src/github.com/elastic/beats/auditbeat" do
      # prevent downloading binary wheels
      inreplace "../libbeat/scripts/Makefile", "pip install", "pip install --no-binary :all"
      system "make"
      system "make", "update"
      (libexec/"bin").install "auditbeat"
      libexec.install "_meta/kibana"

      inreplace "auditbeat.yml", /^- module: audit\n^  metricsets: \[kernel\]\n^  kernel.audit_rules: \|/, "#- module: audit\n#  metricsets: [kernel]\n#  kernel.audit_rules: |"
      (etc/"auditbeat").install Dir["auditbeat*.yml"]
      prefix.install_metafiles
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
        exec #{libexec}/bin/auditbeat \
        -path.config #{etc}/auditbeat \
        -path.data #{var}/lib/auditbeat \
        -path.home #{libexec} \
        -path.logs #{var}/log/auditbeat \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  plist_options :manual => "auditbeat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/auditbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: audit
        metricsets: [file]
        file.paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
        codec.format:
          string: '%{[audit]}'
    EOS
    pid = fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5

    begin
      touch testpath/"files/touch"
      sleep 30
      s = IO.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
      assert_match "\"action\":\"created\"", s
      realdirpath = File.realdirpath(testpath)
      assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
