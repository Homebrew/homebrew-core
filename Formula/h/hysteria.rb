class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.0.tar.gz"
  sha256 "06f86cf466cbe08e7aaea68914263780ed4474cd73df9a591676779535d330d5"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46e68501f245994f2895eacec5699cbe18f4be72de2e5a93c33d538e6d47d95f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c929e8bd369937916e5b718845dc54133d19b0c766ef7134e620c4acfa12712"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8ee87d36f7360ffe8402948cca7afeecc454523c378add397d9f196b6aa3a08"
    sha256 cellar: :any_skip_relocation, ventura:        "fb9c781cb41b68ee2ed77e20aba7ff319efb2a693b529b3d91f7e4a90161ed2f"
    sha256 cellar: :any_skip_relocation, monterey:       "a52e95af5c0fd5d815f7047f0cb33413cd5caa08de9651a566f3e5eebf00cc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbe3a023ac06a3ae9c70aa1fa134d2ea6dfa25a5ae8ac1788830117d283d4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280f8a218cd15eef68ed85839f495c8ef4699f2997353916d97aae3b3ed4042c"
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
