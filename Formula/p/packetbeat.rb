class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.12.1",
      revision: "c7ec8f634ed6052674762b32fa640087d32f165f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1012c349aaef4691830b0869c719cc9d2b9e156a267dd6102b24424592fc501"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f9c45d5ed28e18a32482298c5d9907e66e7576bc5f8fe195267063db843adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3ddf7ffc81fc080863f980fd44fe3bc729721ddfb36209198a20d6d651ebd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b77065b2ed0c09fa0260fbb7be8f53664be230ec03cbee0b1a3665ff8af179"
    sha256 cellar: :any_skip_relocation, ventura:        "295622c03d7c1585442cde4351942d02deedd3b04cf63073328c4e081d00a621"
    sha256 cellar: :any_skip_relocation, monterey:       "71270ae3a3a4e30b4d1a2586bd713fb8aeb55677f5bc680b6dd868400a7c9e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5e4c94688613931498d9bf100c83306580e93160222f4aaabd711e37461c9ac"
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
