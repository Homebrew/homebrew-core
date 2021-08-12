class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.14.0",
      revision: "e127fc31fc6c00fdf8649808f9421d8f8c28b5db"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c68f6098509af8777faf45a9bf3816817af5549dc0072b21bae4742bf6487b0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b8da72ce166ceafd3091ec20682a886ac2eb27dfacf63a3577bf9c3d776346c"
    sha256 cellar: :any_skip_relocation, catalina:      "f2aa4114f1857d76bf110cc8d1f2dca1d1ac3eb61ca7593e078d612eb3691313"
    sha256 cellar: :any_skip_relocation, mojave:        "c0ad59975d41df6c764ad983741b2610acd727b7ba77327499daa20bec854ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d48873c24d487788fad5273af475fa77932dc93e7289614eecde38bfa4b57dc"
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
    eth = "en"
    on_linux { eth = "eth" }
    assert_match "0: #{eth}0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
