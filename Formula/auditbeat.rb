class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats/archive/v6.1.2.tar.gz"
  sha256 "e673b4f03bc73807d23083b8d6a5f45f5a8b3fa3a6709f89881a2debb10a8d2f"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3120f36d9490501621b5c50d4ea494a4bb901d91839b4959bd2354a201c3e65a" => :high_sierra
    sha256 "b01f28aecf59af361f19ef77d61cb4db49f266c104458e1cb89aff8f5f94d41e" => :sierra
    sha256 "2576c543b8594c6ec9e63cd70abc081d9750ff57e7b41d16f17ead684c0c9c72" => :el_capitan
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
