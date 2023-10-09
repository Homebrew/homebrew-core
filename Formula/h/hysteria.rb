class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.4.tar.gz"
  sha256 "cca4b80fa8bfb509ed6da98638962937c7ce5f56bff0d104e5721da1b6ab058f"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "859ea6ed192373a84a23c5b6869dba61b26b9d9722e4a76dbc4383e8f987f293"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438ecf858841b3d79afcb76a43e10ceb39651c702fb95c8b9f91a291469e0fc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36a4d25bf5bdcb77b05c9f60b5810f0ab56a5cdb0f471b7ca07b8e7c939e181c"
    sha256 cellar: :any_skip_relocation, sonoma:         "26d83af6be139a69e6b9357169cf2723ea3dd830394dbf7b4eb36d39c410906d"
    sha256 cellar: :any_skip_relocation, ventura:        "8233f3c2487c8cfe54f15dd6e905dfd7b53067ba87fcbf20f5e2dd2c8c9f17c9"
    sha256 cellar: :any_skip_relocation, monterey:       "99fc1ba1ae5428c387790c394907fb448028a6926f957c4a8e83c95261ad26a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182958ecab5de7f70a309a14cc97f253ff9a183e7e671c46ae126a563f1174e0"
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
