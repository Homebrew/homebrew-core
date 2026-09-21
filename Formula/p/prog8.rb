class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.3.4.tar.gz"
  sha256 "8e1489ce11ff0ec4d2d7b9377f5cfcd648d798e8c0da8471a18df71dec4e4398"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67c81defcc225fff63ab88641a6954a05b37feefd01a6bcb9122c891b99c398f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d21faa9712c45c2b8d5abc6691ef4c09f3d6ce9126feeb34338c6a80b5a3f3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f99189dd1148dec129ba7ce0d82682d1086788e2404d56cc8ba21cbab281eeba"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b163dc73aa9959549159681f0d6585bf48e5fcf8a3c1d87e3d1b925c85e02e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c8fde557cd2452a11eee3733b238edefd75fefc9c6e0c540a5be46038cd780dd"
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
