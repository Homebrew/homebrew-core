class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.3",
      revision: "3747d0eb6c26247477dd62ca51535cff8d6338b7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56b209277ddc47e17d7381a8b1642d3330d474a6ccc949759f556586d60318f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "935d5a7eefafd8f482bba93885be446d828affa6ef1bc85252f3baf1741a7e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e5407c3c084e50109e3fb0ac64eef9b2296999e2b5d70fd2f6cbfe11fc053a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d40391b65252e3e874a593258deb45f67e2a3aa08412a52ac1f5bdfa3c54477d"
    sha256 cellar: :any_skip_relocation, ventura:       "f3f59ca9a72d0459630083d3b6d792407077df5927838aead7c3771b5c01d06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f36c7483509ed7d3f3c51e9e4e2a7ee62791c24a1cb8c2ec7dbf4b75cb27b2d"
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
