class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.1",
      revision: "5ae799cb1c3c490c9a27b14cb463dc23696bc7d3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fcd9f4ba3761b81d7d075658b85705cac9ba0d56cbded58ff4c309a0481e80f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0878d3d9e02b2e1fc6d5ffb9676c2750561f58049733cdfad21eb244c46fb103"
    sha256 cellar: :any_skip_relocation, catalina:      "d47797ee81211e73dac7a616e55800a75738852b6a4522213d15a0c7d60e8169"
    sha256 cellar: :any_skip_relocation, mojave:        "342ed845e196eb6975bd40add28c79cd41864d2ab6b75595a18fa293b12c49f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aece0f09b8386966a81f835c6792068a6d38ce0386ee53c39973826a194e98e0"
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
