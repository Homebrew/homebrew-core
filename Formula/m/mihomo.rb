class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "06aaf2c04f3a13330e562ecb28f4edb101c56a45060b6e116a9683a87e78b6f5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e9bb7e02ef65c094fd95198c889d3187ec9b6f6b548fee685664d54eef386e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c720b2b6151e44feaaf0a4606b0bb643b8690afc0521ef80a3cb70fb3c9f37e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6028fb54d7c3c1c7d6c5498a85b8d60d2ebd26f534d08b7bd95aff8abff9e26"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae3f6ec223f7bf7b05367d6954be5037ea41083b176464c3eff346b3f94d3771"
    sha256 cellar: :any_skip_relocation, ventura:       "0137a44b96f49a5ea2359cd830543592e9443638c5b69326c0b28216512ad36e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f119ff837c80e45ddcc90e7a855021503d08c62ef4370e435d7967800abafc91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee31450d9eaf5b33682f9987edaba1fdccc65132c37a9c7f0d53c77449753cde"
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
