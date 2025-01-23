class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.0.tar.gz"
  sha256 "c9d878ea81c78e71fcb07d47e3366cb4ae2ef5bce62f0ad81e58923db4995366"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "701efaa73fea07a87e95806bdbc193a2b9ef2fa3cdb68a72a3bd889b3cd5cdee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "701efaa73fea07a87e95806bdbc193a2b9ef2fa3cdb68a72a3bd889b3cd5cdee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "701efaa73fea07a87e95806bdbc193a2b9ef2fa3cdb68a72a3bd889b3cd5cdee"
    sha256 cellar: :any_skip_relocation, sonoma:        "b92d5f89e70fd4d2fb0bb9e4840f07f6500e3db203f3bd12540529aa267da5b4"
    sha256 cellar: :any_skip_relocation, ventura:       "b92d5f89e70fd4d2fb0bb9e4840f07f6500e3db203f3bd12540529aa267da5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21782ec948c6ce774c402a0c2729884f9fa7a2ed97c3ffaa09e53325201a6669"
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
