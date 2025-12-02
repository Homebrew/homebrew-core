class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.17.tar.gz"
  sha256 "8f340d40609a55cf02e4a630d51f9515a46780fcfd125deaf2019ecb9b1ee58a"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a06f2714a07be0ded85f3d49b23f34ffdddc3b294a4b8afe6468277e490020fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a60fafbecf85be0cb42e262d92a35d04d5839c46b40d2f8b4c9bcf8824b0572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3989b420a5131996be6e36116f4a3850870e028972a29efc0e1d77e922677a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d082d85993f4323b3d6efa2457dfcdc3f4898b69aa713b29bb38c2dee69dff2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e66cacc26aac00caaec2a0956ce1d8f5f80213ad2fbfc41cd2d44461a7a1492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a3211c42d89bc7daa262a68b98bf6ad7e887ebb8502e953237e7824a2743472"
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
