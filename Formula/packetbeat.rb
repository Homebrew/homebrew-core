class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.3",
      revision: "d420ccdaf201e32a524632b5da729522e50257ae"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100366ee8518563f7cd2b7d3d23dfeee4ff14f8dca1e53806a4e33f823df4edc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e3da8cfb1fab5f8910ac6dc47b24a00043069ae54cc1b6aa580b379e53a65c1"
    sha256 cellar: :any_skip_relocation, monterey:       "e96ec8ec851987296f61a35e01aef23fb93fe7edf155762dd718a8127b53e347"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada2c56c65d6ffe0d44e1de77e323605049a11503765c7ed5ab89eec2d6e6dd8"
    sha256 cellar: :any_skip_relocation, catalina:       "28cc519824cdb9dbdb27d51d04ddacff6d1086715008e739e786a41b076289ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "505324b4defc8cb1cbfd7b3d6e96873d00082501faa5c7bade8accdb693b6fcf"
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
