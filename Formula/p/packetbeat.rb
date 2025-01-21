class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.0",
      revision: "092f0eae4d0d343cc3a142f671c2a0428df67840"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af077bf35a81e393c9bcdf7f695e35b454e22a49b9f3689b028e6e4d5af7421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78d0abe95697db714020390f771bd442859144c9e523cd1e158af12115e9c6ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cc206e810f88dc72fe8f3897cf80b184bc8e601b36884135431512d534362b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5b4e29eaf6ca69c774dbafc21f79599d7708b9f19c87adc6202aaf2c7da78a7"
    sha256 cellar: :any_skip_relocation, ventura:       "d58ec19e96eb6a86df834a2f93d0186ee89157491aefc29f172de8debd3ace5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac72e07b4592bf2b7e9792e6c44c6015da24bc24e59e0188e59ecab08f4b1ac"
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
