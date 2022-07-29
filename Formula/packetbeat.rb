class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.3",
      revision: "1755b5dd3127bf755ee39deb25a802438bdac620"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb61a07dd01526b77f321551772d19bfaa2888f721670b13c5d1d8f01f664ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6fedaa741f2799a493615936005f5d15e4d120db5e70b44deaa7b5d91992d49"
    sha256 cellar: :any_skip_relocation, monterey:       "087a7d4895cfdd52df484b985a005cb560120f64daaa150432a50e41a353f9b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "87e149e548358d1a0b885f8bc45fe338d8f92852d657b9d75d14f9047ba78e8e"
    sha256 cellar: :any_skip_relocation, catalina:       "ff9bac46b905ade75278b3bf99d552b09285483389164088eeca920e8178e608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e9132c2dbb66a6c2d90fadac2a668fc4b11b2354814134260392e0aeca7098f"
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
