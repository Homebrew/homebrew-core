class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.1",
      revision: "7ba375a8778fe6c1a61376a6c015e8cea71caf21"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fac010460c561b2d0e03343eafe83047ade56045c9c8ebac29fb057486a99c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a44dc79ec28d3e0ffaf19bfac8ec575491033c0f5f928097368a22fd4c7a20bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24d52c9646b4ead53b3c9767c921268e8455188815de4c6a87c571a7b0cd9918"
    sha256 cellar: :any_skip_relocation, ventura:        "212bc591f34f1324d01d5505a5f8ee185f98aec07794ba78580d5344a37a3afe"
    sha256 cellar: :any_skip_relocation, monterey:       "d06f7c7d674c8f0b34cd2e6a48e7577103d347bd5e7e2b7995d42adb9b6c47d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "82606c63d48cb0925a84e3e37ff597df1574f1eb0377fac36653dd5756e8d38b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1da70ebe044079d02b13caede2662639e19e64bf3ecc690a83f8e7c60ba219"
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
