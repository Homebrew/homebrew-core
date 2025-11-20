class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.16.tar.gz"
  sha256 "34a506732bf29fb6c39c3e69d226999d3bf0420751a10679528177896583d551"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8606551854513a93cf4dde773707131aca7758aad988b72620fb6fbeef5161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7c764b12014195c7c4a85585e69ef313977aa35aa0ed06a4a77fcd2a0350d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9329eb9e9bc68acd842ce0a7cc0a17c13f9044422a2354cdf1007bb8e8917e81"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea75b1366af71360f4c3ad92f33a6527396b9834d59a76528c0d0f985e7d361c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f689093672e2ce5f11b7c942480bcc39a5b42ff73b377b45a3a7243726696712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2647d09b9870b31efe0754902b065ffaaed59413a2bf30460105b86c908bec6b"
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
