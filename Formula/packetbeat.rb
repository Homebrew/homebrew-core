class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.3",
      revision: "6d03209df870c63ef9d59d609268c11dfdc835dd"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f7b3d4ad70dd7b56ff5d8f04264b0c476a3c301524f2c1de446c50feb172e34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23bc80fe449ae51751e5b0fc9ffde2e6af8ee09728126bf148cdec630fcfe81a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6263a8a0c39ca036986bcf6a6d1f952bcc81317533d0fb0c87c2ec6ce954524"
    sha256 cellar: :any_skip_relocation, ventura:        "4b649191bfe7d35dbb4c3c0d3cbbb2714d149844d4646ba7e27f571cae230736"
    sha256 cellar: :any_skip_relocation, monterey:       "3af025ec417fb1636b53ec5e14e83bd289e61c35ed48f9179df8d29b183cd947"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b16f0186b9c3d4997eef8ee538bef406bb5ada28a061374353272de30f134dd"
    sha256 cellar: :any_skip_relocation, catalina:       "f26c1e805096f5ac1f1ac00905f6b4ced600d673313148167338d169a502589b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23fd8f99c07b27073a59c398e82195298cd86dad3f3cfe01e52c0cc195f4c56"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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

    chmod 0555, bin/"packetbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"packetbeat", "completion", shells: [:bash, :zsh])
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
