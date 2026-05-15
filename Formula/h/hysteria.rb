class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.9.1.tar.gz"
  sha256 "0ac7f4eb6e355621770396aa42c4bdc36ece5e7f3f6c206a1c9053b850cb7a68"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7603ea8d266e80b7e0c8492c20e8ac1ed617075695c4f47663bdfab1cb86bd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7603ea8d266e80b7e0c8492c20e8ac1ed617075695c4f47663bdfab1cb86bd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7603ea8d266e80b7e0c8492c20e8ac1ed617075695c4f47663bdfab1cb86bd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c6a2dd17880a2b40f05603ef6aa3ee5428f784cd1607dded1ec2df4ffcd88c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5135e40e75034882d0735b32dbf73eb4f49cb06ad92b218d38c64f090b97e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "949d46936246dbae9748315d08d14d54d97c4201a2ece303b66aee5bb3aea878"
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
