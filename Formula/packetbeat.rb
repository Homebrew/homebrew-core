class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff450417b30dab9d4a8d2a26b0009e42f7703ebe0738b44737f0c76e072582ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "556cd8ec572847be364cffcf3cab848266729c1f65527b4480ff4da4c8d47b06"
    sha256 cellar: :any_skip_relocation, monterey:       "79903fe47a019ec8b7d9ce24bc754af76cd87ac8698bdf987959aab1ead9779e"
    sha256 cellar: :any_skip_relocation, big_sur:        "15b30232b5a2ace546e629a74cca47663e29c7078b2239eb4549d86a14b86ca6"
    sha256 cellar: :any_skip_relocation, catalina:       "9f44dffcf8c3193a75261e84ccdd2f7cef85462835d393e6f632a7d947011ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e735595986296cded77bd4f0d12718021908705ab908296f6c0bc2154747e4ba"
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
