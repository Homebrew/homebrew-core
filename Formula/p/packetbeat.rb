class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.2",
      revision: "d41b4978ea7b4d7c6020b47ffd8a3b8642531fe3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d12037f180d8ce55ef94103451e51e55ccec5a41b3ecb532524c37675b77c1dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "807ede22ebf93a9749ea39c49344d581660d22f5b05e07b050abd621ecdc4ecc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aaa86e4376e16f0f25d0b313fbcc4d38098f9be44d7fd296267fc9e102ff949"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ea6deff77e43efd442d271b351118a68fe5ccf85df3d870607f66aee596e318"
    sha256 cellar: :any_skip_relocation, ventura:        "8939087dfe4bdfecbe9f6c20975c920b81ade22a856440f32362993a81dd423b"
    sha256 cellar: :any_skip_relocation, monterey:       "1bd99c3849c209f3d66e802923a92c5cca583c57e7359778b96d76ad12fa7d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b1ff18829a4632196c82031332c19fc5663cf6af0f9a71ce7c2997f39bea95"
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
