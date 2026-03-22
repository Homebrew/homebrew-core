class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.2",
      revision: "45ad74566fce5c8c6f1df8a6b90cfa76310cfcfb"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f04563afdcda1bcfa87cd75e9a70fa0d1c8572c49c304df301ed4c373317ade"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a434784b9614670f7c4fc018db993cb23126ab11abb351532cd5b382e47864d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f189487504d17ff1cdb0b17387e38b93369665e182ff64af1efd2410f423185"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a8138d20eba855d95406eb0bde7f9bbf67ee519c72d68912e4e01e4a4b597d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f3d23cb83c0488ce800fe792dc35b4e57454ab79cb4b7db15f8bda44250cbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e150eb129d94a5d5be900667edf6b7bb30ed27bb207ac9f5f76092da3271699"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
