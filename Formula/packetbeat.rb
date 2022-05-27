class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.2",
      revision: "2f1e50cc31b960b1a975f2ebe08bd17be9a5e575"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619de696d76736c3c9540d57180acd31e89238c6ef726a28faa660569b1103bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b9fd2c016c600e511833b7effd264f41db3364a93e2aee85229f2af8d0f3552"
    sha256 cellar: :any_skip_relocation, monterey:       "58735583cc10bc7b256989070231dcd357525ab8f35051fced8b4b5785377e7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f2db3150f3dd38847459b37d8e77c2d4e825a500f35b87096dbfc8f6a3a645b"
    sha256 cellar: :any_skip_relocation, catalina:       "701b58025d93b0b698a44577cfaf4ca8e06506aef46068a6d45a8e62812760ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57036561f111d8f9bc72deca6fb59e950eb661be21b1509b2702a1fda3b18d4f"
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
