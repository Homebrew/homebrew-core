class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.0",
      revision: "42a721c925857c0d1f4160c977eb5f188e46d425"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "394112a8722b4ae46c136d26d1e30d3afaf120046de9d3e5021782241fa68bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8931829add4eef5200a27121098b81a569d8886b1c7880c7d859051762cd3f6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f3173e2df2c4758ca3e9265f19ce3bf6e15914dc9b4e14b639b17401ccc3e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "15ce7d50a31195c8b42be58e57766c9172bdcfa6480a7f122fd69bc27a2a3f39"
    sha256 cellar: :any_skip_relocation, ventura:       "16bef391086763d0fcd7a1c5fc78d1debd0d1f0ef10a3047a350be8e8b5bd6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa0be32fdf6767074dfca9675e33c04ddac170a4563b60a310d575ca39c3fc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84615ac70b5f609928abbe737ddcb8ba317690632604d59ebeda4cb506e96b18"
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
