class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.0",
      revision: "0ee1ead440422ce0eafb95031c0de20180d75a49"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731f786112591192d119ab5b5b2edafd96ce98051ff4958efb6364646a1c680e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed83ff129927302066f43f11ecc265852027e03571c747b11d6ffa02949b37be"
    sha256 cellar: :any_skip_relocation, monterey:       "e8bf7aacb1b9c07247dccb3403a36b100a93cc8ee035fc87d6f91ace872d4b3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c94e734af8bc010da74382c7afc4bffcba465c18b648cac8829a14fe9c276f"
    sha256 cellar: :any_skip_relocation, catalina:       "effc92efb74a1430b9296abcea241228e618d8f8a034385e769720cbe41f035f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5cce13f26a67bd6d9bdfae967cb70334310e8e3b53f9f11f1840691e57960a6"
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
