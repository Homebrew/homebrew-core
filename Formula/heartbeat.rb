class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.1",
      revision: "5ae799cb1c3c490c9a27b14cb463dc23696bc7d3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fbc24a1ee45aff94f696d67b99d8b8dc8c47e83e6a9c1fbc82345a2417c88e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "745829a48ba97ea0d0face59f6d7b7a34d0aa5d0d8f92fb57b3bcbb97fc116a9"
    sha256 cellar: :any_skip_relocation, monterey:       "81dc33b28280bd9e2b3fe6906ed4bb5002d516a9b067950072d5544417b2bb4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "403338b8b7ec4b7a7a33a06b79106931a0e0cc2a538ad45a326445397cea0936"
    sha256 cellar: :any_skip_relocation, catalina:       "cb47554cc8455702ada72f9324ebbe27db3b3fdf62d8c57cc92bf682334192fd"
    sha256 cellar: :any_skip_relocation, mojave:         "5f83bbf5de48d1e862034044ee862868f65d1edcbe323c3b880d66f8138aa3f4"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build
  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "heartbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
      (libexec/"bin").install "heartbeat"
    end

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

  service do
    run opt_bin/"heartbeat"
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
