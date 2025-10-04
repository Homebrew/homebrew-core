class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.4.tar.gz"
  sha256 "9d989174736654f8608a4ba7c1c49306e4b97c6a19d65d926c10a8521de7b2be"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f94a65ee1ad5fb7c89c55cc9ff2e1538b7f55a83ec8c1d71b84201ff58a74354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f94a65ee1ad5fb7c89c55cc9ff2e1538b7f55a83ec8c1d71b84201ff58a74354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94a65ee1ad5fb7c89c55cc9ff2e1538b7f55a83ec8c1d71b84201ff58a74354"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04e8bbaa1222841064376346820ef0d2ab9def4e71cdac9890add0f064c7f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28bf11eb34d096a3bd996d12ceb71e4a97b95f4d06d6b98b9fa3ad847eae679f"
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
