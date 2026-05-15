class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.24.tar.gz"
  sha256 "4509c5c393814d629943ae166e304426dbbbcef41ef3da8577c582aa1c6178c3"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "012d37b4f3e3b3802ecc3c61fdc0916d41b8c22d56e53c1e83c5bc5accac5b8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "012d37b4f3e3b3802ecc3c61fdc0916d41b8c22d56e53c1e83c5bc5accac5b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "012d37b4f3e3b3802ecc3c61fdc0916d41b8c22d56e53c1e83c5bc5accac5b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "283720dc77dd57752ad44d6c45f7a301218bb62e5361a1027af949b22db35c6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a6fbf028ec66f8ad7499ca8932da5bb0c69979241134b42a2e6c891f4116bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdeda55c4c4131fe0afe725cef483725788aff788e887993728eb16761325ed1"
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
