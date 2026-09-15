class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.31.tar.gz"
  sha256 "5a04aa9cf4520e06fa1c13d37b6aca49209479690722d485c40034ab17f8581f"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79e61a0fc7c405b5671061515115feb7a85b913f95e1e87487e08776e15d8327"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c80e1ca3d8ef3d31a2008dc2ca33d7a459576983e053615fa019eb2f7d689008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88978e01874c5b47ba8d61b56ab749d698e3ad6d0baa068da15d80440380260d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c073b56906bc188261bd824a69a76ce171f88e6dcf69af432e4b4632df6e2f74"
    sha256 cellar: :any,                 x86_64_linux:      "ab97993a77da8b388979118e588f0921c2fcdd57becb1149fdbf6ddc796c2ed7"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  deny_network_access! [:build, :postinstall]

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

    (buildpath/"config.yaml").write <<~YAML
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}/mihomo/config.yaml.
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    working_dir etc/"mihomo"
    log_path var/"log/mihomo.log"
    error_log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    (testpath/"mihomo/config.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end
