class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.3.tar.gz"
  sha256 "7bc27f917e86293f3a23a7e14d4583f31b02669f76c81fcce48bb014daf52b6a"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d8f4f0526964662848c95af54b321a3ab5a7f1139655449de111dbde4ed4cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c25af20853302e627b6385a9b6e5a0da3f98f99b00ce7579569c992ace887d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00620bdd5917c04ec8c3540cc277605c79e9c33ad08c037a55b631e1af96e3e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8a8a20febfded5b2b2abc610bbbd20460810e53a4a3e47f6c37bdc9347d6019"
    sha256 cellar: :any_skip_relocation, ventura:        "7bc65361d381acf94cc4bd198e0917e1a2dfaa4538f4274d366fb92610b6e211"
    sha256 cellar: :any_skip_relocation, monterey:       "d77a1121b34c8403af0cecd4e9239e207241cd560244cb4db7f83ddfc988dad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f90c9d03224c814c6814fd760ec7b4208050e46441b01d4497099c90296274"
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
