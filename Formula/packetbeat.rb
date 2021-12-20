class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.2",
      revision: "3c518f4d17a15dc85bdd68a5a03d5af51d9edd8e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b12dbccf7975a58bc1d9cd3851e4eab335f211932c7a980cccf18eeacf80434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86203d818413057263e4b42d8adf0568ab5a98b3fbc429fbd4dcebbc98af73fe"
    sha256 cellar: :any_skip_relocation, monterey:       "bb52262bab08e804cd35b5e87ad68a67aa6552475766500552c289b1737b538c"
    sha256 cellar: :any_skip_relocation, big_sur:        "467342c142f8def7ebb85fa98bf2028abc3424c54b156a23153ecb58c9d729cb"
    sha256 cellar: :any_skip_relocation, catalina:       "4eb39734746cb0516b801acd02160e74654c5f3d795acf441c6be4b011e20048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b590e1c198dc5daa5615cf05b2c755320c7bf8c4eff1d5c6a64fb6c5c9dba7"
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
