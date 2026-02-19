class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.7.0.tar.gz"
  sha256 "3cac6adeccdac7cc8b353948e3cead1eb8606aa8ce74dac4853d821a22ceeba7"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "212021de2cbb445e550c1b63f7706ae018fba2c0a4da0949009ed2d6a29282a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "212021de2cbb445e550c1b63f7706ae018fba2c0a4da0949009ed2d6a29282a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212021de2cbb445e550c1b63f7706ae018fba2c0a4da0949009ed2d6a29282a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "72ebbcc92fadeaa0b9987af7147e2be094dff091f3bff268ae4fe5f24ad73476"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28473a3eee90b7c5ca903575402474d1132bb717cf0f978d90af5c06746579c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c05735794695a334cf2ccf11472e371b8e7347262079ddd648370c4f003d7a"
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

    generate_completions_from_executable(bin/"hysteria", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    YAML
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end
