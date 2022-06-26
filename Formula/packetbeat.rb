class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.2",
      revision: "2f1e50cc31b960b1a975f2ebe08bd17be9a5e575"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69baf8efefdf0af0ed1e6b70af49f0e663910f22e36c1f1a6149c6e56aab63a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefe1f31a3a80a44187a1e50a93c5f8ed41206b9d09fa6c5e482ab3e9562141d"
    sha256 cellar: :any_skip_relocation, monterey:       "f1790296956b6baf648d4f50a892aef6b8a4ae284588d76e4883ff31ebc57daf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc7f2548b7a94874824cf289b963e712326cd32b21f9a819903891c1b979713e"
    sha256 cellar: :any_skip_relocation, catalina:       "d9b1471bcf20cfdb929b4967e6dfc688fe5c1dc2000047d1d19f43f0eb7b4b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c9ef32beff0f445ae14a7e04524abe5c53dd0e6c4fb90d6912188e664434b9"
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
