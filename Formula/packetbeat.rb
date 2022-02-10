class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.0",
      revision: "2ab3a7334016f570e0bfc7e9a577a35a22e02df5"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eb642dae5de6c8cac4d27ccfb151c419d1a72e191e316f1ff8260a784ba2e6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9449e47984caf6f8e6f0203fed792adb07ddee921be5b13a95574509ebb13337"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f3a7dfc4a8279aab732fdd16320a3b5dc043d863faaef8ea0d2d5223d7b5fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4f6e4ffc4456a94d75e2be697bc3bdeadcd7628745d0a78adaded285711ff92"
    sha256 cellar: :any_skip_relocation, catalina:       "206c9fb95d202e5684ab312f45e4d783416c165faf66561f378af9ce39ca042e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866626c355b112531dd6ca6c25acd907f5a6004ca1e4339f546e8fd737c60e1d"
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
