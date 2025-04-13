class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.1.tar.gz"
  sha256 "21955752d4a9fcbe42cde9e491421b67144e0070cba184884ad7f8d4ff1f48de"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893d862f1cc8ff509a85160f845542bed099266ce239d4a678bd51e54c223cf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "893d862f1cc8ff509a85160f845542bed099266ce239d4a678bd51e54c223cf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "893d862f1cc8ff509a85160f845542bed099266ce239d4a678bd51e54c223cf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "edd9a98c25c2d783dd01daa311c6ac7bf37a7251a6cfa6ec49778a78c9265921"
    sha256 cellar: :any_skip_relocation, ventura:       "edd9a98c25c2d783dd01daa311c6ac7bf37a7251a6cfa6ec49778a78c9265921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9dafc3df20027eec5f19fab1a099d7fcc5e5ac1784bfd545c410f370462ca3"
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
