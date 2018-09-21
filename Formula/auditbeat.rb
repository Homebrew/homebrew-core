class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  # Pinned at 6.2.x because of a licencing issue
  # See: https://github.com/Homebrew/homebrew-core/pull/28995
  url "https://github.com/elastic/beats/archive/v6.2.4.tar.gz"
  sha256 "87d863cf55863329ca80e76c3d813af2960492f4834d4fea919f1d4b49aaf699"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebd8f45921dbdd3089084bca6b48f3c91553007a2d42eb222e0b9cf15b1b6873" => :high_sierra
    sha256 "26a317fa93b70509f8885b63981cf3dd7332b825f975f6ceb151b49baf26fe7f" => :sierra
    sha256 "3d639a62737631ec77a87d4f9853f9d653982c39f05dad964cf94de04f9444b2" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "python@2" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b1/72/2d70c5a1de409ceb3a27ff2ec007ecdd5cc52239e7c74990e32af57affe9/virtualenv-15.2.0.tar.gz"
    sha256 "1d7e241b431e7afce47e77f8843a276f652699d1fa4f93b9d8ce0076fd7b0b54"
  end

  # Patch required to build against go 1.10.
  # May be removed once upstream beats project fully supports go 1.10.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1ddc0e6/auditbeat/go1.10.diff"
    sha256 "cf0988ba5ff5cc8bd7502671f08ea282b19720be42bea2aaf5c236b29a01a24f"
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
      system "make"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_COMMANDS=--no-binary :all", "python-env"
      system "make", "DEV_OS=darwin", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "_meta/kibana"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
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
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    pid = fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5

    begin
      touch testpath/"files/touch"
      sleep 30
      s = IO.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
      assert_match "\"action\":\[\"created\"\]", s
      realdirpath = File.realdirpath(testpath)
      assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
