class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.8.1.tar.gz"
  sha256 "11cec7a7c0e366e1cc2ac9e0a83eb89fada88bb9089bc4b1f842dbf720dedf8d"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6946994a2ea9747e4553a77f11aba96e5619b8a3b0136bb09f1e4720af0df1c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6946994a2ea9747e4553a77f11aba96e5619b8a3b0136bb09f1e4720af0df1c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6946994a2ea9747e4553a77f11aba96e5619b8a3b0136bb09f1e4720af0df1c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d133751ad7dcaa380e4f64805319b5e61dbfd24dafec1ff09fe0dd27c2de2639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa26cee50faae61d8df0c68d12c93d8b4f1cb18db46248a3e626d1f19bb4eebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5eb97559917b6c95ea36b7d8c122f81780f0c30b2aa38881b2b86d85f95a0f8"
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

    generate_completions_from_executable(bin/"hysteria", shell_parameter_format: :cobra)
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
