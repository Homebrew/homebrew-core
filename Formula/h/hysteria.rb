class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.5.tar.gz"
  sha256 "21a04ef8ce640d7c60c3b8678500b6e6481862d9af62f9ce2663b772211718d0"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eecc8d7953eeddfd8029cea4415e710baf88dd91a7cb56dd8dac2e5bbe5cdd31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eecc8d7953eeddfd8029cea4415e710baf88dd91a7cb56dd8dac2e5bbe5cdd31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eecc8d7953eeddfd8029cea4415e710baf88dd91a7cb56dd8dac2e5bbe5cdd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5fffbe6c68731d8b21eeae22115ea84600e37648662089c8851ea2c584194e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e836bc634abef47ff748c6ba1adae0477ee3cacc1969c7acc41ed945381392d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aab74d6349185d6b0f514b611e44f0e5569e4f9c07d14afa75570d35ee0ff42"
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
