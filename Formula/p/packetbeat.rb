class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15ecaa25042ccb3003eac02c99410ed3e186877c0d95f9c1e534e620fb5ea728"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f908fcb2eafc45a810d187ca0123a249438c317a3633ca0b32b2c0b22cde12ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68b398cd911e17f58e4209b82a55de2ba22dd278f468a4026fa21aea1d8743a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8c105f8f4ba52c1c4dc8ae6300c6dad3851427849bbf77d5943f09e9f78a6dd"
    sha256 cellar: :any_skip_relocation, ventura:        "b355c01c6c37e79916ff5354079ec2228d91f992955d1eb3a21d462037e75381"
    sha256 cellar: :any_skip_relocation, monterey:       "51e6f43f6705128930d8228f7ce1e7e2f1124ce8555b5a8b05eeedbf9164580c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "496f31f8c883f7a3f57089c52f3f127c236f473ba3ab0913c5535e144a00b8f2"
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
