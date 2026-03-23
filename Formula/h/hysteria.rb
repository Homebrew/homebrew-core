class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.7.1.tar.gz"
  sha256 "2b8e42e965eb1b5215efe58f06a1416b2379b025c79adc89c620c56488b4f08d"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8749b2a53c3868a6c2693ed4f339ee62d72f1c94dffb76fafa5eebeadffc38af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8749b2a53c3868a6c2693ed4f339ee62d72f1c94dffb76fafa5eebeadffc38af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8749b2a53c3868a6c2693ed4f339ee62d72f1c94dffb76fafa5eebeadffc38af"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9339b6dfbbc93c37ec2da860a9cea19dac801136303867e0b204da7b281ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a514fd8872e5b7d0bce77b45b95e3e27b1912b39a154ecd061cf1ff44e16602f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b70f530ca438284197d1d181cff3fb3c635918783d63cde9f1b7a20b94651f"
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
