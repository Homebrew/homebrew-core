class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.5.2.tar.gz"
  sha256 "56acc2c3a795b9f9074d6ed3cf725d3fc491ebd45a10203d6afef927d7fe3c78"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95fda19f9fea586b153fb088b119926ba20953082a095f12d94f2475b5ac5357"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fda19f9fea586b153fb088b119926ba20953082a095f12d94f2475b5ac5357"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95fda19f9fea586b153fb088b119926ba20953082a095f12d94f2475b5ac5357"
    sha256 cellar: :any_skip_relocation, sonoma:        "46f49c9291001c370761ebcea8b6da9656564f9c7cda09637e47dd130d4e7521"
    sha256 cellar: :any_skip_relocation, ventura:       "46f49c9291001c370761ebcea8b6da9656564f9c7cda09637e47dd130d4e7521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2104ef6161f72e7efed0681dc69e411aad1721726996e46db67f5b58690a69c8"
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
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
