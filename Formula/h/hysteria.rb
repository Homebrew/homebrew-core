class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.4.1.tar.gz"
  sha256 "a03d8843048e87c26417c1eac7107aa4eea7f8d5329a18eb56d7ce89f6fedf29"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "121a9d02dcb5858278b20554a782895f4c518ec83a8eb93fdbbf6a7c6a131d9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3cd4c4d66184659056222dd6d417cbfcab4df0d7db35cff6399f16c42e49e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb0f7660b000ac88a713ca420c4cec4bfb4c8a75356eecf690208bba4f73a90"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb639102f2f8f1c6977d4ef3107197a4f9b75adbf1de435685896fea3db5530"
    sha256 cellar: :any_skip_relocation, ventura:        "0b4f8737d8502d8f6ea4e8f3f86d3a35d4038792260ca02a467fd6ce6bc413bb"
    sha256 cellar: :any_skip_relocation, monterey:       "a55903944c47cca36d441f0ba2526c7dcdf40bf0f665bbd67ea7da643c1adee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7c6cdcee9a3b9127f4aa3a23db3b22f6a6dce25aec3bdb7f24409042c74a471"
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
