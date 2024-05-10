class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.3",
      revision: "79b1528b7bfbf5152041db8f4ab497af6afa06e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10a9c074deea7db3d870855db490aa713648c2e874ca2159ca13acca4729b6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4772534d7fdb5fb859b7b50f31d319210270fd119da68bbe20a887611c418444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5053dfde3b6c331b9c187d19dd8647f7a2822030526f33bb2e7faf26982aae21"
    sha256 cellar: :any_skip_relocation, sonoma:         "c91da0eea7964cebc517e2515c0b8a1272cb4d54a1394789b396c7fec554a1c6"
    sha256 cellar: :any_skip_relocation, ventura:        "0cb1f8b8822bb960ddd5185fed5460af1400e2b0f2cbcebedc03c4e776123f95"
    sha256 cellar: :any_skip_relocation, monterey:       "768c825e2db808302e664913c660dfb77c4c1ff2489b671aff2f583ad23e5156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86fdd98b850fa7e0c6014a3ac6f39dd007b853406605cad347d04518c9500c16"
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
