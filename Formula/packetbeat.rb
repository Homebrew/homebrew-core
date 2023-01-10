class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "723259a10eb2d9fac063ddff1ffe3111464820a26ffb3f9b67ddc8f165153dad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "250c2f9943f66b087104757a6476349e6494a55afc8fc53b2c57f015778565e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9503e601dca7c0353f88ea912b2ba76dcd1b77fceb42b158eb24a515318b205"
    sha256 cellar: :any_skip_relocation, ventura:        "a221e1efd25337f459c8c9978e608f68ef402d25890e81a83801ce3832f2996e"
    sha256 cellar: :any_skip_relocation, monterey:       "caeea547be237c4f358804e5eee1faba3334f5c14e17d21fb393357f49928357"
    sha256 cellar: :any_skip_relocation, big_sur:        "f90637d0f003614f78c7fe147767fe992f284bfb94c4be47d6a66557c5a6ebcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e3283e8c621b450acc04ed9850f7aa5b73b13dd3033f5f91f72f0a5eb605f0d"
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
