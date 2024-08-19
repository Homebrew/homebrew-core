class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "e4ff0d1a8762ff3e259e4999d9808b353c7a58a1dcabe87dccc9c91bdb6814c7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2df6df3ebfd439150b8f84af11a0784762c00c84273b34b54cefd46fad23485"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59b174cd3cf6049bbfca92054a9b4604383d7c3cb9f0bd076ba01c45841f3a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02dbd14ec8c070e0eefb8d53782ba9e462cae465b656d6def6d334407fd18e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a1bdce0ffabb98827e4cc8872cffd8ae139469370fb433ed781ef1e0d5b863e"
    sha256 cellar: :any_skip_relocation, ventura:        "e0e9cca3639e784294f6926c0d5e2e23b0eb38fae3436808f4e2df444d4263d2"
    sha256 cellar: :any_skip_relocation, monterey:       "d3ffeff2a73f3623922803df0c4b597af597e7ed7c108376cc2cd4d25ffb24dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3996e627b44b39cae3c0d587e0eb1b3c2027f9fef3f4bf75e29fd8ea33ef684f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", "-tags", "with_gvisor", *std_go_args(ldflags:)

    (buildpath/"config.yaml").write <<~EOS
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    EOS
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

    (testpath/"mihomo/config.yaml").write <<~EOS
      mixed-port: #{free_port}
    EOS
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end
