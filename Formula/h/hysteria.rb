class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.13.0.tar.gz"
  sha256 "dfde427a93a0dc5ff65ddc1e239df3b1def54bf33f8b137c571daa7b27ecddd0"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec0a06ba1440d6d96028a33f5925eee9044669b13d9d0d319994cf36fa74d316"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8533b741108f98aafb2fde18ee5ed3de31d97630db481c58f7cb204c1c2a01f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4f804cd82d363bf3e4088ddd11a2628d22f1e887039e12e5b710ba389f19223"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6976e2a33f9235a6483374d06d46d37b0d321dbea9f8b41f40e84b9c4239b8aa"
    sha256 cellar: :any,                 x86_64_linux:      "9305749be5e10ddfda0485efd1be4e19fb3d06d67aaaff5b8f079341f8203aee"
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
