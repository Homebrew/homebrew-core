class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.3",
      revision: "f81a982a107ef6e450ae5c0deb634fffe8be3404"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a807712f10c47f04300bf3619092a87900b3ab091fdb81ec0d114edceec82900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54425c5de464ab94bbc471b87d253fd52543e5bf930fc2e5a79c814beee180b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4feabde01aecc008bdf041c534412e6885f579221384654852c510ee6071424"
    sha256 cellar: :any_skip_relocation, sonoma:        "431b4e2fb7b66375610ba574077d95f36c8f39d05d5448f530ac9b37c017babf"
    sha256 cellar: :any,                 arm64_linux:   "22c841fa2f8ab51b496d6dd4a50f6c522363521b7536c6cfdc54ddae5ef2b2f2"
    sha256 cellar: :any,                 x86_64_linux:  "4bd1c7f7c7f5ce1f2dda0f433bce66e5cfd419e8606003e4807b13bf65740eff"
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
