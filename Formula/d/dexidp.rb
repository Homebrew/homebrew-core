class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://github.com/dexidp/dex/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "e0599817d14dd1a99f0c7b967b8801751f90b42ad56d8f1aaa4afa2565d76288"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd3a79c12a65cf0c632bbb7610431b24be1627dc712465b5105d1f59c299f356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df23a6fb031357ae2c3095c00e6713a98b74485859d3db36ad8340436309c77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f610bf0613e8446cc7173fb3af3ed417d90c0b3b53743d4e4480ae2670798378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9685e4b7b7b4eba901c45fd435fe84ce00cd579c17fc6661ddeadf6f4407ee2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "65718792e94096b13180875a6ab75bacea96fc24ab490e91bfe86b4b48cc6669"
    sha256 cellar: :any_skip_relocation, ventura:       "a69bbc18f7b28a1a5f5bcf149ed40512ff7a9315212b2cf6c6655e93ef19c47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "986f3525707d3f29dd1ef9e360d45224e9235d784391e48c0b278a635e58f409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e523b97e9dd193df39c627600f460e33331dd0df30f49beb2e20548eaacf12bd"
  end

  depends_on "go" => :build

  conflicts_with "dex", because: "both install `dex` binaries"

  def install
    ldflags = "-w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dex"), "./cmd/dex"
    pkgetc.install "config.yaml.dist" => "config.yaml"
  end

  service do
    run [opt_bin/"dex", "serve", etc/"dexidp/config.yaml"]
    keep_alive true
    error_log_path var/"log/dex.log"
    log_path var/"log/dex.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dex version")

    port = free_port
    cp pkgetc/"config.yaml", testpath
    inreplace "config.yaml", "5556", port.to_s

    pid = spawn bin/"dex", "serve", "config.yaml"
    sleep 3

    assert_match "Dex", shell_output("curl -s localhost:#{port}/dex")
  ensure
    Process.kill "TERM", pid
  end
end
