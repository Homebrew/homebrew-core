class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.1",
      revision: "cff0399d80d4b1ac80f0981be846a50d1ec2b995"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e4c45f7c922fcc47aa5d063e1db99334f4a51490128e9b333caa3933b6615a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10d2f179fa408bd3a2f8bd07c90c5e000f7e9bb98cd7f2b893831cd8fcc4452a"
    sha256 cellar: :any_skip_relocation, monterey:       "e45593d406954fb56250118ba5a7578efde08de0052faddd2db82d4f542d80c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3630411d3493e8c752b013bdf7db380e43f1b3e4f65c81b440cf6a6eb1ee903"
    sha256 cellar: :any_skip_relocation, catalina:       "ab99a360412a3b3f37a619be1e82ed8cc736dada5b2a297695067c31471d4df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0db3cbab628c3102e311b460473530c8d37ed8fddee546b52ed6e22e50487658"
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
