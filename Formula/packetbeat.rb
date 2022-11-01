class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.0",
      revision: "6d6754fcb0adf6a2191b055d35f694c961c8ba40"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19023d571059101f700eda1ac3f8c755365d090276dc4ef5c3b0ec2b0ea58c8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f59c756feeffa45b76142589df793f14e3547d122e5c086d704b783e17e6ccf"
    sha256 cellar: :any_skip_relocation, monterey:       "84623da664635863420aa6f2ef4d3ea08a7f77b338cc335c17fe6e5f717a478b"
    sha256 cellar: :any_skip_relocation, big_sur:        "20f7211be44d281eba319d9599f6a869cc16354c0078ff360aa3e3de601cf6de"
    sha256 cellar: :any_skip_relocation, catalina:       "4d19ad3a6b72d876fdbf16d2a2707f6d8e8566623aa3f75f9523a519b7096a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b43708de45247d90a04506cffb712fa9a82c8615d3f2d7e07839521d5792da2"
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
