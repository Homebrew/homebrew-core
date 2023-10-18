class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.4",
      revision: "10b198c985eb95c16405b979c63847881a199aba"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b58f8d5e7b4186c39ee17b8c092e92698f011743267cb46cdcfc39d591752a44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cffc18c772d54b60b84394615ee0a75fb6055062d7140cdf95f5b13e1c386439"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3ec9e71eeceed947e223eac157aa704a3857aa1a937362bbcb9d8ae85ee9c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d5cf5b7adee983e2ed2baf761cd68dfde1081680b753aed10fb01b9508db07"
    sha256 cellar: :any_skip_relocation, ventura:        "3af43b9b7cef779d4f2e374917fdb69d1c23db574176124a59067f8f51e217d9"
    sha256 cellar: :any_skip_relocation, monterey:       "975321c257b703313d63596c5ce787055044f7a62afd6fc2328f3314a5436145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e3dedac88000d2ddcfb87ebe77c8f5d7b464838942676fbaee35980391a76a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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
