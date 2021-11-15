class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.2",
      revision: "fd322dad6ceafec40c84df4d2a0694ea357d16cc"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0900bc34a3c7886465b15ec00bb81ec31bf92a8c4bbcabcc2970920767fd23c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c6eb51fd1ca2e7d68f411567e86e65bcdd5327f46f48405acaab98918e2d31"
    sha256 cellar: :any_skip_relocation, monterey:       "87e26508668f2890e451224fbba78af6e523b496c86a2c8f9de76aa6e428c21b"
    sha256 cellar: :any_skip_relocation, big_sur:        "690f9a297e1ffdc7021c8c809769d6797ae54a49d139fcad897bfb5a5b9e65bc"
    sha256 cellar: :any_skip_relocation, catalina:       "b2de2360bbd45b90d188b686d25b61fe509235b43af4396760e6e2f6d0673e70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b311f335db38e55cd513814ad7b2ab44f1ce139d2abcdee0b0fb4a62406f031e"
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
