class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.1",
      revision: "471eefbca30a79d543af5106d039bf610a5c3281"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3835d697c599536d85cbbf51e7ada305267f267369e82d4841f9bf4a12467d95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9731feffb2c9ab53da6ce485f51017e6047c44bae09823d21e736eea5b4d9436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ce0da6f6fc1b571b2676caf38e45a94995e77fae2d0d69f2afe0a955c618484"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3c76d59322406d9718d6c3229a6d080b5508193c293acfdf21a5f0c9f4c00a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5cd78e027e8b2756ce2171401f1e08d6273744935c2ad95905a4a9dce87b4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03654ca1b894feb1c326d163b360d4fa90eba6a58fdfcdbacf70eb92e21bf514"
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
