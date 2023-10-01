class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.3.tar.gz"
  sha256 "b79ae98a43613704e31ac085f75d4e11ca741b54294ddf9670378b6fb6c1ec57"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dce1b2e918db298c3958594a58d2c1e6ed24cfe2bdc33f4b2a84b159846dc17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed62fba59179bb18f2b46fcb41ac8c1b24bed3a468f9cc29f7d9ea03296dd9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "518aa7aa081358f02ca5dc0a32b39110ef5efb78df8b18f9e1ac8ccbaf966fc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cf9996bcf375165934af4514c101a8be13fd4ac7d13a7145a4fbfff0d58d656"
    sha256 cellar: :any_skip_relocation, ventura:        "a483e715633d7918c779ebaac8592491e60dd79988355dbface7bcce86d9ed48"
    sha256 cellar: :any_skip_relocation, monterey:       "ac5d9b1a597e09ffd97651f93f9c73b8c53662d15643b60771dafbd656bccc1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dbc219ecb2f45abcd7da44e351d2cac909eeabb3abb08a24a35e834433e47e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/apernet/hysteria/app/cmd.appVersion=v#{version}
      -X github.com/apernet/hysteria/app/cmd.appDate=#{time.iso8601}
      -X github.com/apernet/hysteria/app/cmd.appType=release
      -X github.com/apernet/hysteria/app/cmd.appCommit=#{tap.user}
      -X github.com/apernet/hysteria/app/cmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.com/apernet/hysteria/app/cmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
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
