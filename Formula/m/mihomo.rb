class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.29.tar.gz"
  sha256 "1db1cd49c233b67701b596fbd8a963f418ebeca4cb497f38a0e7cd706ea4c630"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2d067272e9d7b1ce8d5f8fe23db3369513a6b0b881b5d07d9462c4108313cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16941935a5d4aeb1994b2e450272b04bb2a63f8cb9de0f9ce526abd806f00793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "023991ebd1cae74eab4c9afa7e6f55521658a43cc5db57927586232a1980d7cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b8085f8113d0a5d94db68db4642bc01e30dfd59885f583d054d0d9ec7a0d549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9dc5e79d7de515db85e0f66875ec9b1574d2c212641adbe341b2fc213971143"
    sha256 cellar: :any,                 x86_64_linux:  "b19252939c772b67838fdf069b539c4a4bfb1071ae090523761fe42f5f6a532f"
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
