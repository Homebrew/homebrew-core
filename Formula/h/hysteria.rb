class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.8.2.tar.gz"
  sha256 "1704f3dad12ee3f9fc7aeee9ba788fcc1662125c1d05ffd0f1a85ee3dd99bd08"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f3c69ff5a47b16d44ad6b076708c857ed677a1c75e5afb5b6e96f5eae990110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f3c69ff5a47b16d44ad6b076708c857ed677a1c75e5afb5b6e96f5eae990110"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3c69ff5a47b16d44ad6b076708c857ed677a1c75e5afb5b6e96f5eae990110"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d7a383ff65758dee2ed59b664a720044bdb83f3f0b4c2f69dd49370042962f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21747b11f3f0c4c62fd1cd084c92825d80ea2ed323ed9595a5c8cd16f3c64d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97693dc44ac89ec50f318f7cdf5293f6f3327dd7ea2d5f3bd9c7d4ac9ea537ea"
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
