class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.3",
      revision: "c2f2aba479653563dbaabefe0f86f5579708ec94"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a30f1e8f3d05e12796be86f48db8228347c50bcfa23b3d44579fe8dea2e6a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01871a39df2d44034a2420f4123fb41a27ce47bf75e16913c271acf35d040119"
    sha256 cellar: :any_skip_relocation, monterey:       "6bae81c556ab373f1b4d3a99cd85916b9686116c32b4927e514ecbd6c1fd653b"
    sha256 cellar: :any_skip_relocation, big_sur:        "48911ca86e26b7b8329ccdf7ae8edf0dc1e080a561b39437d605ce9a53106de9"
    sha256 cellar: :any_skip_relocation, catalina:       "279006fd43048508d83ccc3f4e67349e262be4216f3c895a770152d16ce28008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99151cdebf773dae2471bb1a330a79a0dfa477c6a2e20446afe8f1e3939372b"
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
