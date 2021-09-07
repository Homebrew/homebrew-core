class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.14.1",
      revision: "703d589a09cfdbfd7f84c1d990b50b6b7f62ac29"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1ae7e94316a389b451a726e07a153a611890905d2e3ec235032713cf50e3840"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a63a66ce1f64ad7443577a0ba230d0378551ef9c86e900f5862b7066a504df8"
    sha256 cellar: :any_skip_relocation, catalina:      "927be059a7cf660c4ee7ce483b7db068bec4a0fc8cedafbe731973688681af60"
    sha256 cellar: :any_skip_relocation, mojave:        "efdaebae96039a2707dd2d7c9db89b864c5b397736c51ecd4b918262d78e9200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4924c52f886333739e36ec4d8bf07ff3081c9f645c4783ca75bd2a44a636c89b"
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
