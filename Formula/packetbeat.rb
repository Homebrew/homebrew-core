class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.0",
      revision: "4bcd954491364231b14d7f340500441af2133209"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6459c24ebf85038762e3226cee8a3f75c31be58de82d7a4ceebc55eda69eb4e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12fd4013f58521d9393df3abaee0dce6fe8d83f6eecc7132b3ba8701e0d9485f"
    sha256 cellar: :any_skip_relocation, monterey:       "a14663ff59cf6125f809139430d5a0d1746fd3c1e25b71b1af2a7b758315cb8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb3d3d81e40ec66dca55ee33d601baa2c1deb8d13bd05b461641e12c6209da1"
    sha256 cellar: :any_skip_relocation, catalina:       "dd21b99e1ba4765d590525cb4abeee07f2648bdca0e744419d346d07b640ac79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fce671ea50085090bae646a8abea22a1ed367248435d26e3bec7e11b52c5850"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

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
