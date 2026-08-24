class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria/archive/refs/tags/app/v2.12.2.tar.gz"
  sha256 "8db04a112e73685a1e5916d5d4d3df3ed897dbabc3e639fda4880b7ca9a7d18e"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96198a0789c732b710ccb76f09460e75b0bc7b9fa3a201e2411b2ffeb2f96f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96198a0789c732b710ccb76f09460e75b0bc7b9fa3a201e2411b2ffeb2f96f22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96198a0789c732b710ccb76f09460e75b0bc7b9fa3a201e2411b2ffeb2f96f22"
    sha256 cellar: :any_skip_relocation, sonoma:        "9460173265af8924e06a30a98a824775a9980234acabea7b11f46fc9dd7442fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c86915f4cc156fa46a053f5b5ccb865974f56c9a7b8987e4c438d1bf5a63fb"
    sha256 cellar: :any,                 x86_64_linux:  "0a911acced4493696869621f004728df8e8e29bc7fc5cd26b66ce0c55f67961a"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
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
