class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.3",
      revision: "c394cb8e6470384d0c93b85f96c281dd6ec6592a"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95fca8cd8c4b06afcd42068e1f959b34b48d94c842445611f28c23b39ae750e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d408c845ab9947e4440adf9f420bd8b7cc88e965e6de546435273c2cd29d634"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9061303b628da6afeca9e88db82704da8b5d29b8dba9a0fb3133d754a9cb47f"
    sha256 cellar: :any_skip_relocation, sonoma:        "edce0fa85626e8a92150a8679acad8a27abab8673de9956c2332293f1c26ed48"
    sha256 cellar: :any_skip_relocation, ventura:       "cc867eec4ce2bcda0c35d96c79ce9c9390ad3d112ef61686afebfb68c630a2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1697565ec4f7a33e2d665cedd30d09dc37e45949e530bb9d8b61d55c8346305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b7f738525c835bbd1d169e531ed7b981031c27cb45892f6a8836966407c76fd"
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
