class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.0",
      revision: "045da3a1bb89944373c33332c18ca99ef6192df2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f31911aaa99f732fb2d1b6ed87c065327e0db44dab9873d47a31a1abab19f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1723b8128167655679400a4c6e07b9328a03379cb0a38cc8b5213d144705c46"
    sha256 cellar: :any_skip_relocation, monterey:       "2661c9d8bc18cb58de91e5a211a1a39caee17ad0404ec4dbbb0bf11b26713d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ed4185c2387f2d90b6a08afc04141ddcaa4a7c0bfb454aacdba6a6f14827428"
    sha256 cellar: :any_skip_relocation, catalina:       "61cf06a34445776c9fc3a665811e35693cbdcdd02a7fa302504abbd574f64da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5893fa91a51f7c8ccd37e0f56a2ae0b7eb58df6f3a21e569e53eda18533415fd"
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
