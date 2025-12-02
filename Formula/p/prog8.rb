class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.0.tar.gz"
  sha256 "fc74e7005306912890040771d851b8bb502f2220fbc9aed2ea30f15b7d5f6393"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a4515641f580e68ab841fea99eb54cbe8892a074e1ea642898c1c04456bc82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a29726a8100f6390a0d78bbc03e575ed2101934bf30a0b85ee5f8386270bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b08e86fdb7cc30d58b079e4226576ea01efe1568ce8c465fc223f064ee05126"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8ef480240dc11b23e667bedb05af14cbec73872b0c42580dbc0cdda22c5f1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a924bea48892ce219f43be39e1e629ad4ef87362c45a90870f809e945f35c2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b15d1f07ebc963b8cf70f885f6af12a31c5e5941ac6284cb1438300607f8013"
  end

  depends_on "gradle" => :build
  depends_on "kotlin" => :build

  depends_on "openjdk"
  depends_on "tass64"

  def install
    system "gradle", "installDist"

    libexec.install Dir["compiler/build/install/prog8c/*"]
    (bin/"prog8c").write_env_script libexec/"bin/prog8c", JAVA_HOME: Formula["openjdk"].opt_prefix
    rm_r(libexec/"bin/prog8c.bat")

    pkgshare.install "examples"
  end

  test do
    system bin/"prog8c", "-target", "c64", "#{pkgshare}/examples/primes.p8"
    assert_match "; 6502 assembly code for 'primes'", File.open(testpath/"primes.asm").first
  end
end
