class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.14.0",
      revision: "e127fc31fc6c00fdf8649808f9421d8f8c28b5db"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "74842e87c168d883bbbe3fd8700e1e83bdf8759bc6e3be25d1315be2c7287f1e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a92df4b10f036748a052ebd0abcb0c16cb4deef4ef4702a3a840629c72b62e50"
    sha256 cellar: :any_skip_relocation, catalina:      "8084133b356072ee7785e49ba9dc8cabca83994ab1c17d2817c2f93a45228f77"
    sha256 cellar: :any_skip_relocation, mojave:        "4a9dff0f9d07a5a773e436400a301d702f3d1545761fa20f1b2931402b90bed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5433d69fa5f2ed2d635bc90563db1bc864a1659e49b8dc1d73d55b3e535f8a"
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
