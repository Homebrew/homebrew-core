class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.3",
      revision: "1755b5dd3127bf755ee39deb25a802438bdac620"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6d711c88aafa71b47d80d0dfabfb1bb07eee55e248e3fea668446a648e30a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cab3e125d7f1dcdbbaa2b31073377e8d78d05a9ff62dd07465da2f4c3711417"
    sha256 cellar: :any_skip_relocation, monterey:       "e44d28f54d47cce76f4140a13d3f91d2b3a7d86160b552825215df0736c20b96"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd72fbe39060b9440237d60bf8c62c5bb7386673a45ce724323109284812506a"
    sha256 cellar: :any_skip_relocation, catalina:       "3fff1bf0c4d60f69099368caff0b60f39b98ff221498f3753b4c1a25c334be24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0744a2db2c4dcb15530428bcb915fcbf08a5c649d3044dcb7710b7bc2c1251b4"
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
