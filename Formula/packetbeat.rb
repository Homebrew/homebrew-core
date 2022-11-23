class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da9709841aa8d9d5cb193b2a5923818b719cffe736c630102c0f27bb948a093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051f9bbc34a3f2b4a0c7bc64c6334d7053c9320cf258c7049c864c6ff94bf319"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3573f6dfd36ed1dd568563db19ade0b741c41fb1fc1928e28567aa9975116886"
    sha256 cellar: :any_skip_relocation, monterey:       "e7fb7f5b48e945b881fa4dd42e2f48c0a73992a6c5c2a251f190de77fd2cd612"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bb630b23f307f4bd762348970ded3cdee792b7b024fe1d9f8be82cefc604021"
    sha256 cellar: :any_skip_relocation, catalina:       "10c5c41ab8acc94f0acce6864421e5ee0f586bcffe9aafafb2d988f776a283a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1717fe1fed3f89ae87e65343ffb4a3d15f53f2e48ea5ebd241949c7b77549ab9"
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
