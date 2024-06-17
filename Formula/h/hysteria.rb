class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.5.tar.gz"
  sha256 "e0d5ffb3ddd5e98092f29e908edb64468b1d8b40af78281cc0054b26f542a48b"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0e98dabf49d2b3ea3f69bcb2b705fe0a324e206b05656f4bf78c0f38a662b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015828880e3e074592c2e2708cc2e22009cba32f0716d140762cdc4b8d304644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c2c6bae783b1ced78d198b51d2a5f4236d06121264e620de08ac26e9df4b06a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2076d200a35aa0d2b3bd90972e2598b9133cc2ef3c3ed92c127507be679d6091"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a254ec7e48d99f170b9d092fe3fc3bb7cce8e492635c030997e7ddd96f993c"
    sha256 cellar: :any_skip_relocation, monterey:       "28d65876f9092408a029e5d21b43220c3a9c997556419b26607cfb672c4258cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ccf13b8564318ef61688edb8e2a37e20b8e745ec2255996418ec053ab024b1"
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
