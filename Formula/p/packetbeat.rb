class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.4",
      revision: "45b2d3821c3ff0da055e025ec16a126c27423462"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de385010896490ab8fbad653dc45d1cf37acf05c1166d4b44880c3f71b09cf29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa47ca2ea3a1de0e2096619f1c9a354fa94b63d060467bd2d8d69aa32f650020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1337e168adf20f09b4915b4667ce5084722e472a0fb35941377055dbd7e95152"
    sha256 cellar: :any_skip_relocation, sonoma:        "a74efee6340d7c9a2f70707db53fc1521620db5a6f4b36d2353bf1fedde4167e"
    sha256 cellar: :any,                 arm64_linux:   "7754af2fd443d2c959bb225546cb5916ea60683c895c58b047f4bad4110e64af"
    sha256 cellar: :any,                 x86_64_linux:  "a9c3f97a53b404abfbe35ee195e617edbf4d52ae8ea347f87e10af22a36815d1"
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
