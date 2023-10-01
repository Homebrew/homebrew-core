class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.2",
      revision: "480bccf4f0423099bb2c0e672a44c54ecd7a805e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0a169afd63c1c9ca663e4ba0d600eea70199fd9734b6f435609a24477a5aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6990c078503cb0b02e7b16eebf9e4670cfc5653b8123de11055ae0a904ca71f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9046c5ff9bddfd20b9fa3f2d0f805647a7abc784038df7ff228fb7443bc453d"
    sha256 cellar: :any_skip_relocation, ventura:        "2524df5d5c112a263dc7b321b36805af1c3956c440279d04631fe7bf9743fa31"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b3a24cb176c7e50752569f173f7dd65a21d9deb39c10efd93907d6230bd5e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "75f90f60bfc18b3688bd643f8fb236ddf976c572b59a757759bd4a642f300b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45ad2ef50578b20014f1fc27d584720bfded0f45e11f1bb577f13729b100709"
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
