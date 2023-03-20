class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.2",
      revision: "9b77c2c135c228c2eedc310f6e975bb1a76169b1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1140ef0087be96e6c1c30b8f861f44032d989f9a07d07672b3e66a7c9367c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bd6987ed007d0899bbcdc0fc85970407ae49c6041ce754659aed3d9bf8e411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e6555b4d7ad895b25b4f3ed40987dd74e05a4d59f9d531c52d21e87acb2be8"
    sha256 cellar: :any_skip_relocation, ventura:        "cc0798d68d5933837bf3e12eeb87599b4206bfab3cb080f7c12ac376584664bc"
    sha256 cellar: :any_skip_relocation, monterey:       "906664c2c86f22bee3c10a0eef872da3efdb23e4c5dabd596e078406777c8c77"
    sha256 cellar: :any_skip_relocation, big_sur:        "0efdfc4195dfec832be1cdba7dacca979c333bfb46c1b58ed1d161716902107d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed2bb1941036300b5176b2cb8321a64d471e7b76abcb5541cea55e2d671ef7f3"
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
