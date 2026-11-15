class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.34.tar.gz"
  sha256 "e3284a44f1052f1c454c90d418faa244516c2470bf232b455ea18fc4f5fa6028"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b148573cc9f80e720a4867b7a7ad739ba1eeb3ee8da6254a1ef80ecac30b37e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "221f46fee023b5681b4f0cc50a4c96926b6e32cf84756397f2ba5666f6d03bee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfcb3c6799a9e36b26c4c7068e31d817c460ad80252de89f86ec91e4f7d7b33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b71261af654a185b408713cab225d2337accc8cb7f62dfaed1ffaac3c01ce4c7"
    sha256 cellar: :any,                 x86_64_linux:      "f3a236b34630d0d8c913f170b74dee9d74168a15e40b9ca23f9a73c738a28aa1"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

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
