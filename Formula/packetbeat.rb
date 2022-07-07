class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.2",
      revision: "45f722f492dcf1d13698c6cf618b339b1d4907be"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35b8bf7b1dd53ab94ac902277ae8c1306c86197f3d0477343486fbcfee47173"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cba9f8d27fc73f53834fae14455c3d94ef62095f71efb3566c408f7b9be351d7"
    sha256 cellar: :any_skip_relocation, monterey:       "52c87a0c245db1ff93e31e4bae94748800ace8facdf81c8a1e8131b2e6c05007"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39993520b768244fd109a6ce17b30dbe6b5b95fcd1e07b2ca8b2c226b2ef650"
    sha256 cellar: :any_skip_relocation, catalina:       "3c32a6181bf6b2d7564880ac97f2b36a353d86cff8a40f9d039653b2bdd9dd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f2065a16582899f2e47a80d226384d35d65ef2ae4c84a4be54dd649e01e1da"
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
