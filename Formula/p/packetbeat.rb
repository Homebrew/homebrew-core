class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.3",
      revision: "bfdd9fb0a3c4eeeacf5a5bc2110164a177e4cb08"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7a51419ef82b9af7f7c32a7f07d67fc6dcf08e1643378a8a1f417bbebf266e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "467b9c2937d6c3f292f4c118079e8dce051cd5fcefe80c06c431462d318bb52e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "238ded83bcd2dbc8eb0072fc3c898b4ae972342df760533288411634c7ef9eab"
    sha256 cellar: :any_skip_relocation, sonoma:         "e47f465133e1241c705e6270d6da4ad3e0ca2769912634d9cdfa3b1248f45cbc"
    sha256 cellar: :any_skip_relocation, ventura:        "af0b7b6ca1fb4e0d8e23df29b72f6efba9f7c298b0ec1d56f32aea2bd577f7e4"
    sha256 cellar: :any_skip_relocation, monterey:       "c767281071c926d5caab368ebfd55a1d5a200ff20498a883ffd83af1bf0db85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95e25882332cf3c0f2d905d221dd1e81677d5f0db6760af96dde3ee6593c9b9"
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
