class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.1.1.tar.gz"
  sha256 "34ede7105af1c5eabc6e457d1eed0b9ef5655498d215197739bbb1c1ed71cc7a"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba0938701b0d057c9e8e37a0465854cad58077ad0a2ea371d57c49ac6c55118a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e31e094f79aef84ef2f706b1a6d65d1f55657e793e83a290021cb92fdd37617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d5adf3941983e932c50416ddb34c455bfdea187387915212f057e0cdfcbfa7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba0760196e702e6b2ce31eb89b30bbc52f2ef9644c34e0bc143a3b427d7301e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be5491e2071cecbe66a83e4fa5da9b4e3a9ef58f0af25c0eb9b4b5324e83ecf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aaaf99528177558c2f1cc6109efd62281810ed8aad6dc307d703dedc763f387"
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
