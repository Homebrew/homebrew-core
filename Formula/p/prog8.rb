class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.3.1.tar.gz"
  sha256 "f73de9784579da94733f218e6ced5377d7450b409dce61e38194c21be4973523"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c385baf69423042ecf1b7822ef481d06e1a0c43d16f5f9e96980867a1af31f4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ec37d0ba72d71e82d83184c006c3f1e3984f70eaf86d19e929b36628d9d5a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5f6357bbde4884a662a1d7bfe2a3d105717d816d6de9d721946a2f88c43f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b852cb016140f57126536808279d805c0a9c4262f00c302214d4f812f7fa70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb979591ee4514c9946425616b94260263fc1ede2a3704f1f416ecb74a1855e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88aec4e10574388a1723043a7fcd86bc333a793d38cbad36024cf3d62efe1048"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: formula_opt_prefix("openjdk")
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", (testpath/"primes.asm").readlines.first
  end
end
