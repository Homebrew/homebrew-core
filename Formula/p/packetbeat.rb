class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.3",
      revision: "67e4444020f495415ad83b44a8508db7e5010fc1"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce4de9d74c7bc9f05d91aaba43f253077081b1156d7d00bef750ca77e14dfa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f2ebaf39a507639063efbd6cb1aed2b16fd214d73db2c041c27a1f6ba931585"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd20dc282317f96d4fb802d576311560cb3e3231f530f16502b6f04d12951562"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8f6da50ceaf29a88e2240bb5596a44553c11a8503231a27a6588844fc0ce36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14622c40a2e4e452cbe081925097e46e899f0c6b2641e2b31478d9c15ae54b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84cff35396a1c4c1c00d8db3fa655e4a7b2df8286471fdac5b8f4c4e2a266cf9"
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
