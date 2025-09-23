class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.13.tar.gz"
  sha256 "dcbdcfb84bde1d70758247e7f3a4fbd4e4771655d01b23aabbdf3cafcaf749b1"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7fc2b40a9603887c40e6f277d172e91608d5a02e58bb2a78513f6e1376907bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "116f651422b003f5a5fa3a76b932cbc916234dbe527f4b83735095d2445dc5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e82642377ff8b32a3353c6112ac1f9f8609d2adf2612d74985c8b7f54915ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d95b1f38e56e0b3c6682828f9d7c827a32b12e66cc84789dae2c4cb7601ecb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29578e5b12323ec449c8aec63871c225b280b96ea2dab21c9d84b6cbafc1b6cf"
    sha256 cellar: :any_skip_relocation, ventura:       "53300a75a5c0b3e007fb45832800bf896f22d4934097878d37d79ec79a16188a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "355c5ae233d5697a50daf747886560e576ad0be2d0e2d2e056b93328f57c1871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2393af07001ecd7269848412774ff10c71a2b22ab817888f437164ca5c2af78"
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
