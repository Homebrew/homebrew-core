class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87c84f2440f9e93650a666b57a94273aa79df2ee6b7983566e6f781b348210a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942e61cea9790089d90531fcabef4438857301936128b03cadfda91f9bfe5161"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8701f0844c1161d15f7df15c3f6dafd0d76f877ccf6f6ad1b882c2633cc0cfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "6396a704a63233b6c9cf45aaf9c0624cba11a7d403589a7a7e7d0d3b6f1afa16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e092ddd06ab6ebac593d73fbcf3b14369eb4241c726e3148e2b86d28838b477c"
    sha256 cellar: :any_skip_relocation, catalina:       "22b8e106700a69e491d607b743f856bd2f6fd339deee65c1527a04d705e18042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126db0a2b7dac3da9459475fc6dd3b1f204a1e758606476472dc6b33c6b15339"
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
