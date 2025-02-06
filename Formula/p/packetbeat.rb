class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.1",
      revision: "424070e87d831d2d66a7514e1c1120ad540a86db"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358c10756bd3d97ece2e3d1daa39a3a437a0669af98b7ab17447460abe85a987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bfe42b0457448d73e4a3346c878b021b005df3e2c2320593c7bcf43c9407c33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19a67bda6183d50206f3b3b887264535d7679bb646e1cfbd4429587a3455c578"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d494543aaeacba5fb7ce79aa7985d979c7a16df10520bafce3d4b2bd0609d03"
    sha256 cellar: :any_skip_relocation, ventura:       "24fa79fc764631381a5db4887719b4e5ec8a70fab70bb27b9253bc5f89d5ed7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d395e309f76697de5df8b294e7c43bc43131e601cb5b5837d516f3f018494b"
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
