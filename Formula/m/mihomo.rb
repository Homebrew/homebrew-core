class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.19.tar.gz"
  sha256 "3e0f06ecf84671d30ac5d6eff840c120d074fe802263738f053c4c34257d0dc0"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4458d597515c9bcd15f3207562a6c57b970f65b0b926f4b8510eebb21dbd4d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4458d597515c9bcd15f3207562a6c57b970f65b0b926f4b8510eebb21dbd4d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4458d597515c9bcd15f3207562a6c57b970f65b0b926f4b8510eebb21dbd4d0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a3c6b58e1846a72c0ccad4772f54ee4239db1feca1e4209709e5e291e8b6a90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac195b12302de54f5f6abefc651a07921d6eb66b2b6db520654dc64ec3af6dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bb8ade75f570d86812d99014cc08f918c1006a259668bfc0b36e7f412d9c2f"
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
