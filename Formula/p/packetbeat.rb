class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.9.1",
      revision: "3799398872c0f33da4e65019390d055cdfe633bd"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8faf750d4ba72e013e4200354d872a50846a19069fc31c4a2c0e412ab55ba5bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca80d0a14c57f40427465a0eb1b9a3f6b2081cc5e6bb56430e603e3b120c8178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e0082f3250c121b559902caf51a5cb90beb2aa230895d595bd97a8c708feb8d"
    sha256 cellar: :any_skip_relocation, ventura:        "f498f21f75aa62b8fa417d5d512ea40f112f4220a70c3b03b7c536526cf5db63"
    sha256 cellar: :any_skip_relocation, monterey:       "63a85bb8805f0ba066ed5f8cb629b1a14d7917242a935e8bd2a8123a8b48087e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8b1904dc200e0af135bec3fa3eec1e9a3c2e9b15ceb08922cd4332bfe6a9bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34b32c69d90061f4e45c316f33025bd5373d1f5b2f20c803ad0a9fcc1dd7b60"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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
