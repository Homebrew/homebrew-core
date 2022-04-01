class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051a6b21a50b4f6e078f46dc32b0e04f6eb6a320f25531d56ce2b71eb47d65fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "974a7ef1883e4566ceaa9ad6765a22cfce68021716e4630d085cf24d29cc84d6"
    sha256 cellar: :any_skip_relocation, monterey:       "7119ca78ec476e8f314cc7f248f65a0572687aa9c4d843c5420efba5e33a0554"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3e8f234f454f31084403ddfa0dc5c5b1a69ce7c4294ca1f4312eae775f733f5"
    sha256 cellar: :any_skip_relocation, catalina:       "e7a462e663d5554abf626b490ee79af7b36b5cc033b91bc1442d5fc6786854fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35fb774a9e5eba9f14606427d673a5168c842a1b464b9568813b44e1261079c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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
