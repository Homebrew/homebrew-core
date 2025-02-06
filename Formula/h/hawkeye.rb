class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://github.com/korandoru/hawkeye/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "d77bd16a991b5a26fb9fc3f1017a87fe4b609e03620ffee7eabb07e3a75f2ea4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298656dedf96ee6154562f68c968b118ccad66133a1c993b84eff2945298c0e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2ca6df7cb95f08a560b79b79edaf701dfa3b1dae03349f37c5fa5cb4309f612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab3cb9f33b50dab657a20612119265b62d5408c90472e1e51afaab1efb49749c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd36cac2560695800545ce539885a1d8647e5926711c43b335b004af124ba423"
    sha256 cellar: :any_skip_relocation, ventura:       "8d1d60e96dd0333993a0739341d47676221fda29cb2e938163e3949e0c69e3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db1a72d4aad82ed4ab69b99d09c331bdaba61cec434a32ce6922c32c6a6f153"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_includes shell_output("#{bin}/hawkeye --version"), "hawkeye \nversion: #{version}\n"

    configfile = testpath/"licenserc.toml"
    configfile.write <<~EOS
      inlineHeader = """
      Copyright © 1970
      """

      includes = ["licenserc.toml"]
    EOS

    shell_output("#{bin}/hawkeye format", 1)
    assert File.read("licenserc.toml").start_with?("# Copyright © 1970")
  end
end
