class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.1",
      revision: "7e56c4a053a2fe26c0cac168dd974780428a2aa6"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32eb5194868b62bfa3d8ca69f35804908137da95f68594bb4b2cb4dc157541fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "367a46aee160db700d0078e166976137acf7bea2897932a4610927f76b6e43ab"
    sha256 cellar: :any_skip_relocation, monterey:       "c5532a5c1e9bee8fe7ddb33f9851e054318f1ce3a7bbf4b6780308370762117f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce39e6e7a82d276e93b314912359ad8c10dfbd965294774bc51186761a74212"
    sha256 cellar: :any_skip_relocation, catalina:       "ee4b2c46f2fa77296ac674759a1af7c1c1de61f82f2104fc777aa01f51e5df27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2a7497d7abe3ba22fead70e86df5745d11827f8a6155b150aeed7b0eac633e"
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
