class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.20.tar.gz"
  sha256 "e2c6b8a3a86d979a826c8e6dd36cf04148773931b75bac72069717d5297b640d"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e25af9c9fdc2edccb826375f2d1aa95bf68a8c16ddc4563efc8db259e33d4cd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e25af9c9fdc2edccb826375f2d1aa95bf68a8c16ddc4563efc8db259e33d4cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e25af9c9fdc2edccb826375f2d1aa95bf68a8c16ddc4563efc8db259e33d4cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "95dea3c0d28c2e0ce0bca93408bcb79c9c5f01290935a8f38ade81756e4eef56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c81ae77cb933fee49102ac2133ebaade990ef597a716853c16739cf91cbc81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde40a6e53ee45e8606a9cdfe08ba6e9b11f6548d117dc45f0b54637e6887281"
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
