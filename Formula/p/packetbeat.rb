class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.0",
      revision: "0f4fc63162db855e0a1c5f0ec5894a8939e31d80"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5c6e7dfd951a8858171970c21312cb9a64f1bcb6e33e8ae12da1843fc2099a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9089bd152c928acb0fc9eec39ecfebd4540dad6b8c49c50ca3ef30ced7635249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e607db6579149b825f497c02cf3f5e36914efbacba911325e9df1c694a1c9a98"
    sha256 cellar: :any_skip_relocation, sonoma:        "e16051c893336d81c05afa9359cfb586abad13176aaaeb5d9e83646476d57203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6240848e800f4bd6b3d038108f865b5849cbdddb33509c04a7492ca788e3c588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa3d02df684395c33d28c3b55e608f93926efd4044488c28c9dc0536c39b225e"
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
