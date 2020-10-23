class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.9.3",
      revision: "7aab6a9659749802201db8020c4f04b74cec2169"
  license "Apache-2.0"
  revision 1
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "933dedd05884a96dc3e01e54923f5a2e15ae15a8f9f86914e55118d3df82f8e2" => :catalina
    sha256 "fb76b8006bb6a9235688945fdd1240b064fd1144e502749c3b9b261200b89756" => :mojave
    sha256 "e78c9d62f7cdf340729f2cc846629c9ffc34b1227cbacddfa606c41c37983d52" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "python@3.9" => :build
  depends_on "freetype"
  depends_on "jpeg"

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/28/a8/96e411bfe45092f8aeebc5c154b2f0892bd9ea462d6934b534c1ce7b7402/virtualenv-20.0.35.tar.gz"
    sha256 "2a72c80fa2ad8f4e2985c06e6fc12c3d60d060e410572f553c90619b0f6efaf3"
  end

  def install
    # Fix compatibility with recent setuptools, remove in 7.10
    # https://github.com/elastic/beats/pull/20105
    inreplace "libbeat/tests/system/requirements.txt", "MarkupSafe==1.0", "MarkupSafe==1.1.1"

    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    # Help Pillow find zlib
    ENV.append_to_cflags "-I#{MacOS.sdk_path}/usr/include"

    resource("virtualenv").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin" # for virtualenv
    ENV.prepend_path "PATH", buildpath/"bin" # for mage (build tool)

    cd "src/github.com/elastic/beats/heartbeat" do
      system "make", "mage"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--use-pep517 --no-binary :all:", "python-env"
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
