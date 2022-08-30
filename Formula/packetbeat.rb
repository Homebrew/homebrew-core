class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.1",
      revision: "fe210d46ebc339459e363ac313b07d4a9ba78fc7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6ca2497f53ea61eb1c64b2cac292d005e8b6fc5298f5761a1e9a5938d14eb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5ba81a7589337c328ba418d92329a6d0e518827cd26f9414ec531337bb83871"
    sha256 cellar: :any_skip_relocation, monterey:       "0ebae72fb6c26d34362ffe06733c798f349e1633ef4dcf83f856b41fc8926457"
    sha256 cellar: :any_skip_relocation, big_sur:        "c497234d5aeafaafeb13b64dc860544e20bed42549e034f23bdbb8624a0e9ad9"
    sha256 cellar: :any_skip_relocation, catalina:       "7d06bcf616767f935d174ccd255612749fe057912bfbc53ee3142f5d2a77bc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f7e6075e9a282eae3d47d1c2aeda1fe9e8db0702f4fe11951af081d5b860918"
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
