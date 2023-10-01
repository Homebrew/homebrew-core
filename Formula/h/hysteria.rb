class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.2.tar.gz"
  sha256 "eec86966a533cb4bae8e0e7b5a1c9b231a0a7a587ebc07a2a2e1e8cdb3f555f6"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a65acb4e6fb99ae37f92a4cfeceb6655ee5853e3901ac7ffc6787ceff9abe7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8c28ccff4d6f39530c898270a9a19bdc89246ebc06247209a7fd391990ad86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74399957a1d610ad6ec14eb61903a0b46d49bbe4bee842de952ed9f176f25cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "611ba6af23526c3b393d98d5176722f80a32a25462fa0e4139ff6e739749e6ad"
    sha256 cellar: :any_skip_relocation, monterey:       "4a184d026c02ebca8fec29f1f865dac71562c8d6bde323b27f7920a471d857d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5c75016ca6a0e8a3c15f1c0132fc03485aac12ce058a8500a858253a9e71e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31f27d20b99c8e5e416c1bdaf8f0891a76fcd13ee31b309328159e06fe093309"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/apernet/hysteria/app/cmd.appVersion=v#{version}
      -X github.com/apernet/hysteria/app/cmd.appDate=#{time.iso8601}
      -X github.com/apernet/hysteria/app/cmd.appType=release
      -X github.com/apernet/hysteria/app/cmd.appCommit=#{tap.user}
      -X github.com/apernet/hysteria/app/cmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.com/apernet/hysteria/app/cmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
