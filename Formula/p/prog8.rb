class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.3.5.tar.gz"
  sha256 "e347107216577ae1c3b2c876d9ddd127a8113f6ab4edb2153c6afff49bf88465"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d03d41f353bac8a9e512f015a93ff8f493fb90f16382678b524b9ec13275856"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "44b7706fdf1c8d126ab55d9b20bac38029dc4836b21a54006515f5892c5e3ef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "679a03c0982563c55905f33a4faa094d0973b937c96566eff9dbb7062d2fdc2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c623c100046e3d8c3f510537457d7da95b29717e293a376e08d2f873698876a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "127c7c27eba1cf47e73f144839c03afd5b089cbf7057fb6c458fc0482524c52d"
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
