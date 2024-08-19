class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.0",
      revision: "76f45fe41cbd4436fba79c36be495d2e1af08243"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec7316bd7c01ab491ca01602fa8db60970476d741903e32b0f11a64de9cc4d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ec544fce3c672b0cda1a8abcf8cdddaf1999d0b852fa25676d06c2f29f49c1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8e7d2b5e1b7d2a7a65338096e6e52d1121b1c7e7f05c1bcc346374b9e23edfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2cc83f19b97d72f90595ed71e3cb37cf7b688a1d250471248c6c8faa58e4f90"
    sha256 cellar: :any_skip_relocation, ventura:        "f2771191795f54cb15a3b5c409fc7f06dbf79ad5685f0b7028b3b9005cc5e1b7"
    sha256 cellar: :any_skip_relocation, monterey:       "ee7ffcab5c832fb03714c0460225bbf340bf823f06169f2132b0f37a903f7b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d107044abd8a6f3e24d50f6235829c5c5e1ee73c3330c1c9c88f8769f8127e1b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

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
