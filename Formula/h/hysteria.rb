class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.14.0.tar.gz"
  sha256 "2808da83ef2f4f76be91f7ae0df7518f1cc185d5410cd6d174e738527cf5545e"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "154c1089f27ea041a062f955dcbbb50cdb1afa99ef6787ec03e5f1d0a9bc2174"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58439b7cadff9f84cc8e6e06f2d090f50c71e3ed5f5999eedb6fac6ee902aef2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27c5d763c11e7179f6f8f6497f349bf28f27babd2bb68651c683304f47cb9bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c7369bca31b102395a829fec9fb064a5315538a56b7352208e170d643f65cec"
    sha256 cellar: :any,                 x86_64_linux:      "38c7c1d4bf103c1f32a6cab8f90f47d74aecdd911f5bb06a752e5f21c7c8eebe"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
