class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.17.0",
      revision: "93708bd74e909e57ed5d9bea3cf2065f4cc43af3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e9694b4555725877b9e8103b2c369fd6221c5467b5d18a77d5a874be86a74dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8be419aa2d9a8b40be52e84282e5a8a9aeeac442f7a453d30243ff549c157e53"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5bf40ae9f299f47aa473f1edeb502c7aa5356c50c7f8deffb1c990106aed61"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6c8da21658e998dc7c0bd12f76afa765ec4b530ae0b73ba47ac23717636b4a4"
    sha256 cellar: :any_skip_relocation, catalina:       "32327b72675eeecd90d0509bdb2d4a3d6d0a48d9700c6cbafc056d2b9b201952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1711476cda8221d698869cf89534aedd0429c3ea92313b53ad598681688dda8"
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
