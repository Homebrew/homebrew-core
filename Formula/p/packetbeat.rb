class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3041a15fc298d6f0bbe4056991be39fcdc467eeff0f0f9108cb28cc7582f498"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "762bd3fd9fc4626d5b695e2366ae106ba4827271c2443d3addeec09b0129890f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd12b33fbc7996a698adc26b259025f72b947e5b73330569439d28dbb77ce73"
    sha256 cellar: :any_skip_relocation, sonoma:         "41baf4f9c0c8a940b9dc5195cd74dfeb81cc307fa7ae2f5467740c9dcc0f1807"
    sha256 cellar: :any_skip_relocation, ventura:        "af06dc566a71e668b340c620c072e27cdcb75e9ad5cc751180705e4389e2a6b9"
    sha256 cellar: :any_skip_relocation, monterey:       "940438b7632d76f533378ec3042ff8db4393a04659b2630801b05ebb35791a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a62c7cdcc1880a882ba1b34227747758370ea3b2b77f3b57a27bf44b12a556d"
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
