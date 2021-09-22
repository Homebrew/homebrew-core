class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.0",
      revision: "9023152025ec6251bc6b6c38009b309157f10f17"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de42db73084834b863471d74684b1da5aafaa1d2643dc05c956751e2f8feb461"
    sha256 cellar: :any_skip_relocation, big_sur:       "4241b85b0718c290f266af5b01af0d06337c233d3e3a80ebf9e2fc03d12e598f"
    sha256 cellar: :any_skip_relocation, catalina:      "c2cc9a57035e06369b0f6b74507fee4f97796499ede0dcd255ffd28ba9a97c6f"
    sha256 cellar: :any_skip_relocation, mojave:        "7253cce11b8bfe416c86f5790361c0fe092f487c13c48264226283796350480e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960932f2701ce227521b90c74eb267323506f56e67bc2b22bc8f918beea391f4"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS
  end

  service do
    run opt_bin/"packetbeat"
  end

  test do
    eth = if OS.mac?
      "en"
    else
      "eth"
    end
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
