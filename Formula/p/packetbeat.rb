class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.1",
      revision: "c74896ed7acbb92921ee46fa5e3d66d575a8b0a9"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84f45454cd4d5083ffa70cb43c281d92d9fc09a4e3c2a0ea148f7abe75547111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10801425c7e4b3c81c4994d5ca86d4b95a4c658fba0c5a69251e8308c661e079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58997e5c2652a4d2d424680608fa75caf85ce3a71cc1177837e0d61359e2afdd"
    sha256 cellar: :any_skip_relocation, sonoma:         "760acc71f044af56b3f7d0838657e3a714a876ba0aada6920d64b4e3110f3a87"
    sha256 cellar: :any_skip_relocation, ventura:        "9a710b85eadfe60b33c09885f2570b80bea03d02d4ba3541ad7a30c8d87d04fd"
    sha256 cellar: :any_skip_relocation, monterey:       "e6dada317edd69e7bf2498811aadb3526bf4ae1629a9a0769fb825046fc07fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33ef92954cdab4e932ee90279e60befcb8b5fcdfacfd30e7e57f058c762a9769"
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
