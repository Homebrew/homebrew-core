class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.4",
      revision: "7f7d7133471388154c895cf8fc6b40ae6d6245e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5f9d7f52c6ffcf6501da1cd8d184193a3fdd50f7ab01c5aea36963e45ff8a0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c1c4eb979de75b9f8123da439b4f6873aae5333f302223f32084eb023921eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87bf1553f7be86abcc7165e9fc6a516a5c4017c214556cb2d9674886ad7f2948"
    sha256 cellar: :any_skip_relocation, sonoma:        "83b9e0714b62c7a88560256d19d9f5c96db37553a551233336814aa9dc205bf1"
    sha256 cellar: :any_skip_relocation, ventura:       "04982f3c23929984b0b1d9dd003ddfe3ca17723e02601b6fc975b8bbf7df2ab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d13ba0471a183545b877405c8d041ae451e8a9fbcf987919579b774b3f0a8595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fef920dbf3c7a4c50f2748ad82e0b2af158315b24bc81a71e15e95d3cd71562f"
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
