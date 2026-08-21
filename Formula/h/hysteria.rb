class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.12.1.tar.gz"
  sha256 "6bdd78678f25b27ac984fa6bf394cdbb586c0d02ba8057b5f598da690c61115c"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "239c2eb8bdcc5522741e9753f342d62fa1e5a6d3e59bfa847e236a9be4519b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239c2eb8bdcc5522741e9753f342d62fa1e5a6d3e59bfa847e236a9be4519b35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239c2eb8bdcc5522741e9753f342d62fa1e5a6d3e59bfa847e236a9be4519b35"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f04febb1488e4ba8b26663d0101edd9965bbd7d982a806b9659adc271a95c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d62ea2e7b6bb4deafc8ea0249eb44e05e17c4ccb3e26c0a5e6254f9d6bd6e1d8"
    sha256 cellar: :any,                 x86_64_linux:  "fc07c85d5d671bf27059fd80d3696653b746b00a6224969d14aee27387b6923e"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
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
