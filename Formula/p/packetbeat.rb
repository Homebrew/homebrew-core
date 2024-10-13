class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.15.2",
      revision: "26daf71e4ec87172523af7f0e916cba9f79dc0d0"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee620b73d24d12b61b5e53679aca4f761854774c0d5d0da9455f5497de1494e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cd48f6cc0bce24d1eb2071ff977f036e1f76281f10e78ab05708200b5fe595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9acbf15c914c7744293a86e08389098eec9a1214a17f1a8bdacaffb932767241"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef0fe4fbcf93ccfc720fbe761d2e2da328fd11c322a1abf2bacc438c8c38cdfc"
    sha256 cellar: :any_skip_relocation, ventura:       "1c038f6a906cfe79c84352cd0632455133e79847dee9689b0bcacfb5fd5d6065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca2df3077e536108af5bbf788af0b8f04150c0bd472e5636bfe22871e18d7bd"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "packetbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS

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
