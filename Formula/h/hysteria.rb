class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.10.0.tar.gz"
  sha256 "2c629f1ee327841c0288c9662fddc663eb53f3c76922b4660421a474cdb6e1f8"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ef337b80d2d5b1c0153d71eba671ae14ce8cfcf44cb0d33d3512bc109d24f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98ef337b80d2d5b1c0153d71eba671ae14ce8cfcf44cb0d33d3512bc109d24f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ef337b80d2d5b1c0153d71eba671ae14ce8cfcf44cb0d33d3512bc109d24f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "36923f8e2f41f133857e3367d00f11321b2c9c66b91819293d9f6fde8a654742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fae04c55afd3fd264c82986296b209424a90cb4ecaef6d1b2f2025f79f8439e"
    sha256 cellar: :any,                 x86_64_linux:  "ffa60a8a88e775aedb4cfb81b29844d7293dfad7f7b77cb5791549aab058343c"
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
