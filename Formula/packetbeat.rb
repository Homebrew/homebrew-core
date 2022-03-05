class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.1",
      revision: "6e9dd49b5da9c045125078bb95be9f0dc27e8263"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfd9610145038f7ac193c16843d07145894630ca572c2bde95af55288382f974"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53fa8799495dcef7be1ca214b9af289aa318159bff7f231ead9060775bfa2043"
    sha256 cellar: :any_skip_relocation, monterey:       "243a333e3d346a915cbd33903d2db969044b30516d4e1fdd2bc3ade8bb3415ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ad577b35a2118131e7f488d40637e343ce85350e67aa93e0b397cfc6b003ae1"
    sha256 cellar: :any_skip_relocation, catalina:       "8d408349bd180d574da274ebe0825f2d50124747b2fbbac4b32246a112d64772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a6f9aa912c80eff523285e0ccfe039eb0a654fde3a734e70d1c0f8b9cebf89"
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
