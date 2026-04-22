class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://github.com/dexidp/dex/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "6dc9bf768d67723d8117268d5177c7450519608f5403cd10e857c89465fa2b9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15141e3dd75c5bc4e0f665553457211b74b3833c6c5926973a4d661f7a9994a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6ab2b2c4aaed2d3e57e28a85909980ecebe65889850d7e4298ee9baed5b9e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d4965e80f2f6201d6c2d801918a02484c5d998b8d4bafbdd27f760922025e22"
    sha256 cellar: :any_skip_relocation, sonoma:        "384968f300366d8edba254f785db8a530e7d9f39cd9c0570b2d57c3d380425b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa05dc5aa680b8c18f7f487fb252540451a694ed4cb3f81c37a0adb197bd1d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecff412bcb6adc3c72ce03780b650dd123cf4b403c66e0c08baa4ba33f06b019"
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
