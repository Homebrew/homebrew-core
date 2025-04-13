class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.4",
      revision: "5449535b768a9308714a63dc745911c924da307b"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833f40e26a377e42438180088c918175ddd5ced5834715b45199de31a653d40b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "255e42232ba03cdc8eb382140aaf1c1feae976a99896a01f4a9b6b5202b4dfd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ff7216bb3f68f53673338ed1dc9fcda95c50696f6a6a88c4068f399ca42299c"
    sha256 cellar: :any_skip_relocation, sonoma:        "99b5fca4c05c23035e72bb8386c1561f4dcc7c122260eb75ca224ef5cc62c94f"
    sha256 cellar: :any_skip_relocation, ventura:       "11e5e8e78371528f5c4bea0771ad55c5b2a0ebc018c26df2021a8ba860c36d59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "619591a45a0452628abd2d5894ce156ea403f06a60f303c2f99f9740d76e647a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbd4c653f9c910af147ace523b55a98935f61641ac93cfbf8d1569b8d67914e"
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
