class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.9.2.tar.gz"
  sha256 "d3d0e7b2e49f0cebb861fb215aa1625e4efa895a902d768db7ea45227d88b555"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f11d979c0462bb60749915eeb953754e720056050b75075ffe38ef5975b73805"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11d979c0462bb60749915eeb953754e720056050b75075ffe38ef5975b73805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11d979c0462bb60749915eeb953754e720056050b75075ffe38ef5975b73805"
    sha256 cellar: :any_skip_relocation, sonoma:        "989e501798a819d372e4d508c0367f7f3cb112aa17a17c1c67cb243226739290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9fc42dc9074b42e025cbf4bde45cea69898f33a72bd35a28644a27a04c9741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf4bfe658f90d0b1ae97e618c5b0890e2c846586dbec74d881b2708e4c0610e5"
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
