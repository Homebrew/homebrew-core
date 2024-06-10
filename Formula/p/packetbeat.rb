class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.0",
      revision: "de52d1434ea3dff96953a59a18d44e456a98bd2f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7a5a43fc58ae21ac46ce7295c882ca2a000e060da5a1f63753a806afa314ed4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda22f57422e34b55ae00606cfb4da909809c997afbfd4308faaa86a4d074469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fb7d9339067dd4b2d9807e39a11ac952d0503091d4e53d166edefff532efde0"
    sha256 cellar: :any_skip_relocation, sonoma:         "525cb8a4247fc55471ff6821d33b6dd8e650cfa9e66075606cb0637ad28c8ab0"
    sha256 cellar: :any_skip_relocation, ventura:        "f50b86903bf8de6e0ba11b03fb67a4c34bc593b9c933a850c58a974ba67173a4"
    sha256 cellar: :any_skip_relocation, monterey:       "33c8ce0beabecd2bd814f64c1c438af3904586be0c2c03993f87db40d70ec07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f5d1391cf30cae4ca05b740756d7deea55e2608df46df6fb57ce9d6687cd88"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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
