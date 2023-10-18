class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.1.0.tar.gz"
  sha256 "f3163b5918bcc197e32a1448aa6b7f2dcf3c0f67eed8d603f8bd5bedb460f68c"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "444c931701cc32b818f1f44660b3a7b61f47e134385386f45b169636fa34cd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "664f1dc6dc4e95ca0c8d077df82f97482ba429e56ca526fa89f9765c7db9722f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95a7a8e5bfb8749a5fd0ef26d2caaf54898def2d4890ed316dc37c0d60a3c91a"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d3375b8ba63c80eff43c4c64b1faa603c51d20a437904ebf0852f04e20c03d"
    sha256 cellar: :any_skip_relocation, ventura:        "8ea4511288ba712efd9e9e564f45047155f97df783687867cb1a1f90d1763e5f"
    sha256 cellar: :any_skip_relocation, monterey:       "459b775899149517dbc888ec593260d4725c1250fedaff8da5c6177760b59582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0516c69615696f4e5258494ff76d0ad6418ffe2b6981662fec7315f1b4ca033b"
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
