class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.3.1.tar.gz"
  sha256 "422f4c0da3d81182ab92ce761729690322a632be087baa5a6c1e9ef8c9827ec6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1f9c9f5ea277e8e91be2fdb82e5f5b75d2068be9d5f84c2227c9084440710ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59e74bbf9bb2ffcc46edac8e2ad6196d6f35ed4b3c075e334a895ec72bd880f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b74170737b1ff7770dea373c38967cef5d5c3fa91b290266a9c0700adeb661db"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f5db5419f6f6de56899450048af0b14e91c449ab6e8b38c3b2ebde1927830f1"
    sha256 cellar: :any_skip_relocation, ventura:       "2c06d315c0891a11aff0e61e8e7abe27ffaca0de46a387d7fbb5befebc3f2c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cbf2b9fcd1961b727872fd9ad3d0eb2b032b0a7b9550586f98e2a4a84a070b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52e4af9cbf9a7e8ecf6655debcfd73ac8552f6b5b03766f0bc9b3e0f8ff554a"
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
