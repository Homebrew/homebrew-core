class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.0.tar.gz"
  sha256 "7776ba22b76446d6c71f496be8e635780f1b219c7d0d3a3bd99ee81067f8c8b4"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "662e1fb957d59763ab58a3677d957ad42e346370864b4e97fb36f97157d0b168"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b58b175e2d5445a16183df1b0217cc350b8a6b9ffcc8e80c528e3a879aeeeab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7389081bb5c7c356ca138d0caabac6a5fcdf3c46a39ffc177fa65c082bd735b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f169f14f2a4e241805ba47026e8f0970eaa36b7fda5eff2dba7738f815a85bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "7db539d56e61ef53d1c1caf7016db873b96eb8cb1a0704448298fd67adabe4f9"
    sha256 cellar: :any_skip_relocation, monterey:       "feb79ce73c93a213d30aa5d9d553a015f2ee1a8f71f918347ca4f0a2a0123c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46429565e831202e0b8237d86c28fafa28d9069dfcdb55c2eb9e579e27451e6"
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
    system "go", "build", *std_go_args(ldflags:), "./app"

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
