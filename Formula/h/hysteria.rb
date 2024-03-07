class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.2.4.tar.gz"
  sha256 "efd15d2ad1fc13a42d0e4a75f5c7396b1219e9923a10ccef2c6f45251266c9a5"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfc1c39a5880bc281286e4b43a970b38ffc0a72ac224398441a67a481270ac9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f633ae121d10561417f8484591d5cf47c7979f61346110a931304323d2860206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad3715ec8073b370a1ec8416ac40c64c01a0efa1dc16da73de53c36b305d33f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4299f61e9b0588fb72a0e089233fa90ad7691d3dce5303ba83978b7cfe97e474"
    sha256 cellar: :any_skip_relocation, ventura:        "b7102bc70707e0b8810df93d924c5f16aeb9134f11dd8da9415767546b3cb236"
    sha256 cellar: :any_skip_relocation, monterey:       "b789b4d75f3e8ffc7564b6e4f52c3410818274142557a3e79da299f0a7c98d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f09f47c450a5d2d650857a945fefa089052464fc5b3d0a5854cd321499bc4862"
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
