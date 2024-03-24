class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.0.tar.gz"
  sha256 "7776ba22b76446d6c71f496be8e635780f1b219c7d0d3a3bd99ee81067f8c8b4"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bcc2435f85907ba426f26d47f84a116c8622f88417c5319b5a50185dbe85a2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e969d25f830564da7f24640aa28a61adc9cfc88ca003f3e7118650d048ad261"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77ba34c22d633a9018695f0a766be49bd82f4c7e1b4a7196eb8c59857ff466d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b53736bcf499afd7e14af8051c36f24aaa8458b22e53e0f9645f84537abc5fd6"
    sha256 cellar: :any_skip_relocation, ventura:        "63e304cbea61c3bbea65daad47496a5b7cfb6070f94b5ca7d10f92870bb4294d"
    sha256 cellar: :any_skip_relocation, monterey:       "3d7f1358d1a1a936113c53370e9f4879ef39fe2668b8777b0e9a505f1085a481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30e2172041c40bf3323a2247afd070a31877b76324f66698bac5da87e5207f62"
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
