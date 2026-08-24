class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.2",
      revision: "8f4fe1e5dec067a139dce33d3af88c24b58c3660"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7797de65bf0e829c5408a0dc4192d190d663b2d193f345f8d299f74ddc9a839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48b20fb3d7588f72a6e2c8c18b0f21a64349c2d74b738805de7c9fcbfe4f7d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4529256a9f3182a0543415a3616232fb15b6e01eab229b4b53ea2b1ca1aff4a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cdcf5230c93f649d3b4f2f65c4504fecf7de7da43ad8eafa253187d8152d7b4"
    sha256 cellar: :any,                 arm64_linux:   "a938a2ebf14582a16326c0ebed0aa0f59a40235c37841981f0b02c9d976f5e25"
    sha256 cellar: :any,                 x86_64_linux:  "d8093b7495f2797e0bbc2abee049999e83bcf7d6bca23ad6303b29a86d5a2f53"
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
