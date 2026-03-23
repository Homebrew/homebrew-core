class OpeniothubServer < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.2.21",
      revision: "8f74cb3b31de239bffacd911cadf079d04b844e5"
  license "MIT"
  head "https://github.com/OpenIoTHub/server-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bad32effb7697b3fcad599e1bf94b1ed933e7e203c6b222144e2ac56a53c21a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bad32effb7697b3fcad599e1bf94b1ed933e7e203c6b222144e2ac56a53c21a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bad32effb7697b3fcad599e1bf94b1ed933e7e203c6b222144e2ac56a53c21a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1886c9bf8ab0e8a51090a16d5db9f8cd70380f66acd5e19eeebb844dfc29b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0196a667c244a6ff9990a1d868b57586c2db9bc985cbb7fae53e89827001ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6643e097efcc5db6041532897358d56d10bf2a06a809116d448507881990da"
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
