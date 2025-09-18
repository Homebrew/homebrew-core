class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.3.tar.gz"
  sha256 "bed1ece93dfaa07fbf709136efadaf4ccb09e0375844de3e28c5644ebe518eb0"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb36905f828a2e6581cd06822fa165f9e120bc67ea626ea3007731be7e3432f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb36905f828a2e6581cd06822fa165f9e120bc67ea626ea3007731be7e3432f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccb36905f828a2e6581cd06822fa165f9e120bc67ea626ea3007731be7e3432f"
    sha256 cellar: :any_skip_relocation, sonoma:        "29fcebc3dd2bf199d60c193a54e0c2a411269f2a4424766f0c34ddb17c786742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "840280317f40bf9515b1793ac780e17b9e9b25b9bc496c96f7b2a7bcb906bba9"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
      -s -w
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    YAML
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
