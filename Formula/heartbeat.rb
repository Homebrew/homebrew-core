class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/products/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.8.1",
      revision: "94f7632be5d56a7928595da79f4b829ffe123744"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96e18434c1c8b7821b39e1b52bf533a4cbe700bddfeb28cf08f7da56fe1a4f54" => :catalina
    sha256 "f42f3adf941675175c22f4b042994a0599874b0b099b5cfa4daf786e1646127f" => :mojave
    sha256 "7e5e842f010bc9d036038d30783b041bfde8917a071cf1abcaeb9178ebc02822" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "python@3.8" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/b1/72/2d70c5a1de409ceb3a27ff2ec007ecdd5cc52239e7c74990e32af57affe9/virtualenv-15.2.0.tar.gz"
    sha256 "1d7e241b431e7afce47e77f8843a276f652699d1fa4f93b9d8ce0076fd7b0b54"
  end

  # Update MarkupSafe to 1.1.1, remove with next release
  # https://github.com/elastic/beats/pull/20105
  patch do
    url "https://github.com/elastic/beats/commit/5a6ca609259956ff5dd8e4ec80b73e6c96ff54b2.patch?full_index=1"
    sha256 "b362f8921611297a0879110efcb88a04cf660d120ad81cd078356d502ba4c2ce"
  end

  def install
    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("virtualenv").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin" # for virtualenv
    ENV.prepend_path "PATH", buildpath/"bin" # for mage (build tool)

    cd "src/github.com/elastic/beats/heartbeat" do
      system "make", "mage"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
      (libexec/"bin").install "heartbeat"
      prefix.install "_meta/kibana.generated"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  plist_options manual: "heartbeat"

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
          <string>#{opt_bin}/heartbeat</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    (testpath/"config/heartbeat.yml").write <<~EOS
      heartbeat.monitors:
      - type: tcp
        schedule: '@every 5s'
        hosts: ["localhost:#{port}"]
        check.send: "hello\\n"
        check.receive: "goodbye\\n"
      output.file:
        path: "#{testpath}/heartbeat"
        filename: heartbeat
        codec.format:
          string: '%{[monitor]}'
    EOS
    fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)
    sleep 5
    assert_match "\"status\":\"up\"", (testpath/"heartbeat/heartbeat").read
  end
end
