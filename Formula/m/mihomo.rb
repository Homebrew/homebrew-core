class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.28.tar.gz"
  sha256 "ef0483e3607fe2b2dc99bace17bb2d93d98e501a40797999a13fc96ccb2256e1"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da760ed6e43ae8c6bc15a46ce19309bacaddf92b66761f8b4982106dd5e9a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd1a7774c4c2c4a992d5a70df566d7639f91e6b12ab0a5efdb39c6ee29645851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab27a8df858ed583df8119fb4a5aa22e19cd01010c27d5767e1a4e55a540eb10"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ad312652c1f9e33bb0a7b3f24cf10c090a35257240a5c0db4686fad83475f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ba3a3b916c1dce2e66c50499c19646b54750b79ff86506bb8cb8e13702b3a6"
    sha256 cellar: :any,                 x86_64_linux:  "fba0aff4abf864da0fc78e06cd77c26c42fc40b428206bb6e330b9a054bb475d"
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
