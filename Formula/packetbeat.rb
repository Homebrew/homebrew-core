class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.0",
      revision: "045da3a1bb89944373c33332c18ca99ef6192df2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f65696b21ca45515413ea58e87badf2971c1ef487487fdb637fde8414cd24cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1929e45b0b6f7f3a949df9e4f8d88971b49038b5960eca63183e93f082264581"
    sha256 cellar: :any_skip_relocation, monterey:       "1aabe496da8bbaff0eb4ce5f91e738e168ebddb5bbe7dfb93a14584060b03148"
    sha256 cellar: :any_skip_relocation, big_sur:        "77b0d66d902397109e248958e6cbf02a0dc59efd6526554b94bb5d359cfad862"
    sha256 cellar: :any_skip_relocation, catalina:       "b9756f8b1f6f64d9a4b8e19501af7ea879d885527e49f55ad41b86bbc54472c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bec80e642ad4d98904531954da2593644c03fe783319bd41024fd814b3f44140"
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
