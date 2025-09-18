class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.3",
      revision: "d9d2860c7593868e25d1b2da7da43793fe12c99e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba0f0d56035850394282f32c127114e5735297ffce4b1ee788196b5f1f06a4ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edfde8868bfc86806d60f85d9a9c62c2d1a8e282f3f74f8312f55b55fe62973c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f196dbaa3aa13f0e92443049cab00b208643c4701ff74cea3feef22a146f9542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37194245de803b24f3d426db77ca777f422e29695455e664f899ca7015d39746"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a01637482cc8d1598e0e98955e3970d15dddab33850dae699242de44966da2b"
    sha256 cellar: :any_skip_relocation, ventura:       "a86cdfbdc95f75242bd519111a04a831bda872cb54b0713b5733a496727801fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8fff220d363af966c69d7ea694dc884ca75d37aea9b8cb4988213c3bcfee35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582e70385c8069e242b7b40033e1d60b27c8a68fe7f66165711e69eeead11d8f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    # remove requirements.txt files so that build fails if venv is used.
    # currently only needed by docs/tests
    rm buildpath.glob("**/requirements.txt")

    cd "packetbeat" do
      # don't build docs because we aren't installing them and allows avoiding venv
      inreplace "magefile.go", ", includeList, fieldDocs)", ", includeList)"

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      pkgetc.install Dir["packetbeat.*"], "fields.yml"
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    SH

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
