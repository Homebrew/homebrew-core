class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.1",
      revision: "53197d5422766e985c2aa0f56607750d34d0e912"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18f227e1160862aa65131baf04acb17898c953d8d8ccf3d7040b82b9c064e569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba32e90553a0de5156bf8d794b5921510ae6387e59e348062835618f3baff101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e16073847b96f30f4b2a7bae0be3e7c9e3555db35700590df1c5862055c6ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ae14ab20214bac5d02bb7f4d3c40f82f06ac3202ad7a55a6467ea751332770b"
    sha256 cellar: :any,                 arm64_linux:   "72c93547ab76e007dc15e5c550a99865f94f3fab794ca99b277efbc4d85990a9"
    sha256 cellar: :any,                 x86_64_linux:  "51a706e76ed98dac15dbcb6b381211957e57ac815cff78c2d9780ef30a02c740"
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
