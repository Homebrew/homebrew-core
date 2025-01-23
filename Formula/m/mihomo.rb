class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "cf32a96bea6caeb2769e86e3001da67d332a673fc6db703b5bc1a5d14754daa1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bd1c71970b8b4b877f61dfb029cee22cb270d0affd3a36642e326c58a2375f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe375cd2fe2e94bf8304f37e8c97c7f88606af6924ecf48f258491aa3544d40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f35d3230615d2743a6a7fd482cea4c93c8d8311a63920571fe01a377f89f064"
    sha256 cellar: :any_skip_relocation, sonoma:        "94a1d4cbc170fd4b3a25302c9c1b9b2106479ec2e31a3e11da2266896826062b"
    sha256 cellar: :any_skip_relocation, ventura:       "e2ab5f41f801543136244b6a698fb80e2cc2115b46bf45501971dd8038a494b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31566243c3288dd8511ee5b59e6de5e5dbaf7b5d87a690abf5a321ffd228dcbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

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
