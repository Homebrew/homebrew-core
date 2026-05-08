class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.0",
      revision: "b988690b1bd5ae02f00c3facb413d4ee758563fe"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d65becefd997c3eb232f976209868f6acb45ead46093a515bb778439dbfeaaf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f71428dfeb2f5d06ede3623fc62c24ba518d0876bab14fa7cd9059e705142cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eaa14d556be3b7041b6d855db4cee1d9860083dd149fb2f117fd6a81d4838f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6597da109db87a8a97917f6bf772b41df0502e37bd9682b3225f6bca711ab137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d0f21565824613fafa0f802a957aaecfd1d236d535968f7e5c1d03691a2f08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac5d52052c7ca0fb4d283eac5222fee890ed6a833842d92ec92f74aff283925"
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
