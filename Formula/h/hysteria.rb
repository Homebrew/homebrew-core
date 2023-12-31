class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.2.3.tar.gz"
  sha256 "123bc416b21bc7288a24504915d81b87651f4b1e1b93805a69864e9adccf1066"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "771a9ac3a4d9bc9d45688f2e39524ead80e04ad5c5245ca57307313af5538357"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ef88a0ffef42851e8c86de61fe654e3c550d78e88ea4880f15ef60de1169a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cb45233306a4206cc303260c3e7253d649f184c0729717746cab7a0a1429afe"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b271537d1d07f825d3f9815d0fdded54076e33798b8b92234626da024d63580"
    sha256 cellar: :any_skip_relocation, ventura:        "4ec8ebf32e546b03e43ecde38db30e409d0cc15b064f1217e695d0147b737605"
    sha256 cellar: :any_skip_relocation, monterey:       "2379104258d9c62011984ba3e48b42a32964f2d7e502890d117b37f53422bb61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947015ad022e376fe5ec80b316fa0d169fc263dbf21586dd3f2ee983cda3ec63"
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
