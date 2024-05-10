class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.3.tar.gz"
  sha256 "7bc27f917e86293f3a23a7e14d4583f31b02669f76c81fcce48bb014daf52b6a"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12ce60e98c5c1f25583cf298dc2e70d9eea7f610e2d42d2bc77e954c84a9bfaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb18a76dc0e64770fac70dbd6591a1849b44845fc574261336861f85b34b4140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "941ab800db9594e64f18a1f58e4ce16e1d7c9d28257cb939325b23fbc76fa97d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfcf47cb173d255ed0c48d57614c3d4fa5eec9fbdc9f1899d257ab5c1ce81fae"
    sha256 cellar: :any_skip_relocation, ventura:        "677d6d9e731f29f108cba392521f3780b87335a66c7b715f367461bea9abc4f3"
    sha256 cellar: :any_skip_relocation, monterey:       "391c09dd98eb0129ba0acd4846e816697f9ec292099bce830d6de1bb06a4ee07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3c19f03a51206906daaecb838c526687134d0dcb2991ba3d32d953a026cb2d2"
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
