class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.3",
      revision: "c2f2aba479653563dbaabefe0f86f5579708ec94"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76f5f63b100dac025d793cc4631ec986110f04c3d65680c9ff0cc5d0f75264b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ab46410546d0d835f4ccb52f6d9452daaf7f264c64b95029965836a6d4ed875"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbf9cbbbc425ac3d88eb833c4c45a0c85c2f5d81ed62912b3bbd6c91b37c1cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "72a1f489f6382b4b56e2df7a1f48c1bf9f0460240f256853f65c2c506f16ef5d"
    sha256 cellar: :any_skip_relocation, catalina:       "ad63b997c7216aa0b088829c46a825f75b40fec18594e8b0f7c5c994f3bb2504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82d3c49d53e597aaf971e90bcc8a25c2033251eb8c66469a4a0ad4f79eeb8cd"
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
