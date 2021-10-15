class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.1",
      revision: "5ae799cb1c3c490c9a27b14cb463dc23696bc7d3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1d887c0f7076735406de0c70b1026577ced4d73a9de8adbf147a996d48673b37"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf100c46077817995a2379e1177504f63213e100ef89660a6b39c2e00aa4ea68"
    sha256 cellar: :any_skip_relocation, catalina:      "c159636b3ca767819fa875c4818bdcd399c716b8f34a61460adfcba1adba2021"
    sha256 cellar: :any_skip_relocation, mojave:        "b869c5f9ef25d88c3e44c53b0e5d475a677e71a44d179bb682d63faf09836dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ab0a640315e6ea6ea8e3bbe0db8021da00a032faea51c3af9a34447c7a7990"
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
