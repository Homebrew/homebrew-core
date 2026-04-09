class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.23.tar.gz"
  sha256 "4b162dbdcce983c867a1c92aa9cc56583dc4f3d47d1c144548cd8f590528fc21"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92adcde8dcff76507abfa0b53a95438bcc715756237dc93870cb78f257e8442d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92adcde8dcff76507abfa0b53a95438bcc715756237dc93870cb78f257e8442d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92adcde8dcff76507abfa0b53a95438bcc715756237dc93870cb78f257e8442d"
    sha256 cellar: :any_skip_relocation, sonoma:        "760f10bd695e3cd00396a474c552ea05c4137bf7b922bf140cf465b9d3482fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bb4bbf141a5c967a5217f3fc39c52dad12bf0a63f55963ab81493a57d30cb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ecf15d0bfe3135378e355702b2b968e1982f37c8d3a3fc72c4db740ac684840"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
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
