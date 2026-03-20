class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.21.tar.gz"
  sha256 "5ec56180650d95f8d4898af6c9c21afae8f8becfa1e613a8f14a8f3da45646c8"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77db41b138a7cd37d625c601b9f58ed0cce08b8b4ed88c5edec52270710d6e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77db41b138a7cd37d625c601b9f58ed0cce08b8b4ed88c5edec52270710d6e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77db41b138a7cd37d625c601b9f58ed0cce08b8b4ed88c5edec52270710d6e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "577209e5f53cce1ae0e805226883cba517c5ede8855b4618e0481ebfb9f2558c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb937a26910df98b3ac06eae90a8820bf44a435456618da4ee68939bcfefce99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad749c8ed6318b716390ffe3e06bc8197c18aab26f827c68402c836e499e9ac"
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
