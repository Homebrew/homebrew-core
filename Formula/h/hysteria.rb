class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.2.tar.gz"
  sha256 "4699431f0bc826da2bbd3939c0a78c4e7bfc02773fc3a62b24615c37ee89b266"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e48d57336bc8c4410a5620b8a1056ac0f448545a8c39c5ebe01b2149c3de48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e48d57336bc8c4410a5620b8a1056ac0f448545a8c39c5ebe01b2149c3de48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13e48d57336bc8c4410a5620b8a1056ac0f448545a8c39c5ebe01b2149c3de48"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6839af9a06324ba41871ee52fb649158f7b424cf3357aaf485fb840bcba8158"
    sha256 cellar: :any_skip_relocation, ventura:       "b6839af9a06324ba41871ee52fb649158f7b424cf3357aaf485fb840bcba8158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff66a91a3e261ed5a1a8f6519e15e7b361a76f5bfc6a222165220a54a329f08"
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
