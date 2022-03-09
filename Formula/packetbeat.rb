class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.0",
      revision: "da4d9c00179e062b6d88c9dbe07d89b3d195d9d0"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db9116237eb34e6f5d839528129326f95391dd4c705900ea1a3025c336b0906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cdef56089c465c947d35500d03a7406d92ac0c119bd1f70a70daf0b05d95226"
    sha256 cellar: :any_skip_relocation, monterey:       "b0533b020c8c2d1489b0c8e431895c056aeebcd297a26c7fb050c3fe2d1e36e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c6265d1cf290633e91fd04a78ef7083a332528210b4737e38762764710eafd8"
    sha256 cellar: :any_skip_relocation, catalina:       "f4f3e649bf77fa64eae59fb3ed4b3243b35cc0ca82b93f70ab85369284be1f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b111e35dd7e76ef554ca7397386d799842f45460ca1e609a0bf23e013c339878"
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
