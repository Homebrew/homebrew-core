class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.4",
      revision: "fd909e2bd4416ce14162971875d6013334f6fd44"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ef0f6a0f91303ff126f583261366810dd614d5f28d615adedd76e3aa0d1dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8623155f7c95974e2899fc7d54786cae971f6f506c02e6739927bda33a124d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "effed25c92b3515743ba467252bcf8da36efb361af7c727995df0036216bdc0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b8f705a59f64af7aaed81d2a5dd9ec7624f72c0a3cd4e2d5e0e51d7ec517e51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fab8eab2d78134406723a817fc30dd38f609cbcc302da45370fb5308fd52662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ab72a8c1b5e4a7b05b528b5b4df7212df342bdc059472272b00b742f72f430"
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
