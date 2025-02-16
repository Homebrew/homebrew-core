class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.10",
      revision: "f7310370514b5b8af3deb750636cb526532488e5"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ff60cb2080f4e92c45ee271102c92674ebee6deb262719f7edc4b7120c8d4feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "640c7715e7a89f0c7e0b9ee212430fac3932ce414eca2a47f7f1e359de104fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640c7715e7a89f0c7e0b9ee212430fac3932ce414eca2a47f7f1e359de104fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640c7715e7a89f0c7e0b9ee212430fac3932ce414eca2a47f7f1e359de104fa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec2d884d8a4fa8a523ee7e93a915ff880d245df19f626f53e307648504c6437"
    sha256 cellar: :any_skip_relocation, ventura:        "dec2d884d8a4fa8a523ee7e93a915ff880d245df19f626f53e307648504c6437"
    sha256 cellar: :any_skip_relocation, monterey:       "dec2d884d8a4fa8a523ee7e93a915ff880d245df19f626f53e307648504c6437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1c53efeaa347391a0546b0dd71e20a371885883a3ed96029035ffb546d809a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]

    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
    bin.install_symlink bin/"openiothub-server" => "server-go"
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"openiothub-server", "-c", etc/"server-go.yaml"]
    keep_alive true
    log_path var/"log/openiothub-server.log"
    error_log_path var/"log/openiothub-server.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openiothub-server -v 2>&1")
    assert_match "config created", shell_output("#{bin}/openiothub-server init --config=server.yml 2>&1")
    assert_path_exists testpath/"server.yml"
  end
end
