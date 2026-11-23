class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.7",
      revision: "9455ccba703306aae4ed36b86a03976c963c0186"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    manifest_sha256 "57d7a0ccfa3ce0ec333e422ec91ee7f7ddae0e5da20d4e7b81d9d3a1393f36f8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0ecefedcb462d6ab102b68f5b013d4b0d68036b6a2682b5cddce1598d935af7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "291c6c7e70364b89a0785082740deacddca683fee7a3f2df2c589cd84e4691bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbed414cc9cec8a81c2bab20ac77b7e0a7adae51c340b659f1edf328464d49fb"
    sha256 cellar: :any,                 arm64_linux:       "ac6abc0939b20a8711cddd515cc45fc7ae25b0657635e9022f5b9314548e5baa"
    sha256 cellar: :any,                 x86_64_linux:      "47e27b038559863d2762c8196b2b1459680531ae1a0975a6ec6fab2928acb4b0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
