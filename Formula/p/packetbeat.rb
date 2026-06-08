class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.2",
      revision: "e98b93df5a916738f04a338ea2ddcf53ebd0bc0b"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2b86d9a8b9d13df63bc0ca5194f90f4e45927d79e6674184df7fbf547cb4599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96611e2ac8a52c3c7ba69b14494b86c9e7a97dd16d26fcc58fe3c902f1f6972d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab1b38f74a6392ee281e27fc35453586ce24c1c95e54bb7239866330b0c20b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "09273f67e9fcee7f087310119055e76a721721a5b9468c130bb0c1c8d7cc8f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2a34dcecfa25731e9b51087b0030bb71c75e246961b1f404254a2ff939dfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e14220641523e22ccc5247b7c5e0b73f6aaa80c9146ea5e214f2e77bbff4ae3"
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
