class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.4",
      revision: "c50e2cc4adfaed4367b3fba44d27db0222123cec"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b684cfe94a0c457333e799387b5d01c7633f668f7c7a824bcf90db5caa0c6e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a88444c15841bf0814cfc27c9e2e5472d39ccf05761dfa0c0a5c0f9f483d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d17c6c5f94a81e92deb0729b3c7a0095527f9b686abe74579b8a75b7b51f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "067b8c8bc3711b5ab5c9989eb31020fc3b5de84c22a0053cc0096f763700a128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d7ec47bcfa039173aa220ba8124289c18402f499755e3dcb7298df013bbd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061cd36eb0ccbbad6b8751ba9083b624c7ee67722cf20f1629f19c1665088c58"
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
