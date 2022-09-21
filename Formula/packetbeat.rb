class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.2",
      revision: "b00a6bca7be493b01a134a6ad8c415f2be297414"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd34608afa9637c2a2c0cf7ee7a4bc83dea40c227fea4fc0443d8639ce67bb48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7031653d44837a3536b49abf0d8024611873d3ba28d687448cd57cfe97a8fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0682da837b47253ea1baf153f6e8a69daa4773fbc6f9039d33e238141234d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c640e8ff4b3afc38f1bacaf043d12946f3fd3a869cb86007029990be9b50192"
    sha256 cellar: :any_skip_relocation, catalina:       "d02abe34cc72280aa9e6118fa7ae675d0324477b160a7a9fc24928f29ababba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ce3cf26140c161ab967cb6fd672f9bf193681353cf9d0c9fdc8cfe404c67d7b"
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
