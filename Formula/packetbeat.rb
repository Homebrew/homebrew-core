class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.0",
      revision: "a8dbc6c06381f4fe33a5dc23906d63c04c9e2444"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d9828a1c94fba688448f279108a00ce721573fce99a9db7c652796b1b6dac40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6c59fd7a87d4bff963fd8104e1a999b8cac01e3616137e89b675ffef1b34983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c863e45ab63d937e7ff76ce25a309d799c75a4e9c709d6a53d35a54434bce76d"
    sha256 cellar: :any_skip_relocation, ventura:        "506d3f709b957b638130ab3212290410c9508fb080f932f299aacdfbc02398e3"
    sha256 cellar: :any_skip_relocation, monterey:       "e72bfe7f82428b361abaac599e2f7861a308c0466a02800cd56b10b89294d80d"
    sha256 cellar: :any_skip_relocation, big_sur:        "80b85b73546ff21ccf779f2d91fa27de7dff0b386882dee2c7305a67e519d22a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c3b6c863ea494e3353e851da51fdb1fbcababfbf65a6f6c8f8e385e57a8b81"
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
