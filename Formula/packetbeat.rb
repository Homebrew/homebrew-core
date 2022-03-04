class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.1",
      revision: "6e9dd49b5da9c045125078bb95be9f0dc27e8263"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e0c14990ebfae1b4300507845094132cbee713b8ca5ff9cb3cfeb29a19a4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2ed6bc7151ee3a4aa6bb2230599bf449ad3457e70ca92b500e8d076a3415898"
    sha256 cellar: :any_skip_relocation, monterey:       "726a98f34371da04d453c82a45669d15dcf3d298670be227cf4553443eca4b71"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad9a2ae77eec3525de6118e01b4b9e1daa079f41b40590d58afb8ef689309c25"
    sha256 cellar: :any_skip_relocation, catalina:       "49e449066714cc7e4211aad9eb039f2c011b784193dfa6d0c3ba8501597c58e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba5deb32f5c26982f3f893abde1be4fece9dba3b431b0a785ebc713bae30a95"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "libpcap"

  def install
    # remove non open source files
    rm_rf "x-pack"

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
