class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.9.3.tar.gz"
  sha256 "ba7b924d348ce0209bc0a09e84068dc8f71a1f9890d9fb2f7a092fd2a6e9e669"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f289d6df886419cd8003da5c00798a502729d8d182979b81d10adfb1dc2a29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f289d6df886419cd8003da5c00798a502729d8d182979b81d10adfb1dc2a29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47f289d6df886419cd8003da5c00798a502729d8d182979b81d10adfb1dc2a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce737417602b818b1bb9c2098f444f239149a78f88af9fba8c909a0c1cbce2ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9dc243558b11a6a0b286e287738a80ae8ead88852abfdf6af3cc76373c343db"
    sha256 cellar: :any,                 x86_64_linux:  "d026b0c7651b5b689eaa3125dd7552184f5051ef136a29b22bb8c3d7182f5a48"
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
