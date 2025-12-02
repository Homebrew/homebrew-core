class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.2.1",
      revision: "6485e11edf8854d7792dfc2999bf19db37315ea4"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853cd396172db1e9d7f220099caf0bcefbd32c1bc20d6302dc626b4ffe0e1c74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f80ede3c98ed3fea66d2d5004f9ec5653c56a524ce495bb8b479f457516f57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33b1b39b9658b2159269729665e4006263c7bf94b7d3706256ff3830db5d186a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e7fcaed29e18a8804c1662238723939975a7cce5c30ec1f5ad84eb79523b1c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4294093ef3fd224ded0d980cce71bd9d085f0f1f3c067849c4ea66d8c65a56b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b49c1e590fa281803bd8511181d70bf9c8e6e9b9e5713a0109f4a7b613f1659"
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
