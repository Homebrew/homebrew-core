class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.1",
      revision: "bce373f7dcd56a5575ad2c0ec40159722607e801"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ba61fea2c646b41065635286bab932498249d95c0e812f779f3dc133c9ca36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26941adacc26f1853a73aabcbf0db0602e8bd6552b2115825b8e70c7b03d7317"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f6e26237d347c41163c0df987d711d34af5a4ab4e86ad537f9477184e4da781"
    sha256 cellar: :any_skip_relocation, sonoma:        "8498b02c67f6843fffae62598ccb3994d54ab57ebbacc504cabf6c712e7baedb"
    sha256 cellar: :any_skip_relocation, ventura:       "9d35526cea1ee11edbc7606026cc49bcf377a97e514fdefd50af5b6e7967aeef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20da136b85fa68abd4468e113813cc269cf55f5dca3626a563330ee10e544505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b488e505a3b595b8b3de004e148994405cb9cd1ec3251fa687a3087da5ecb90"
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
