class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v12.0.1.tar.gz"
  sha256 "e3da29f62c530c6618261298d8a2edd8741fe36e6d0d05d17b3803bdc2a305b9"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1675118a9bfaf79b2552d33dda5d05cd93a5e8d7c403a75ace4341fcdc07cb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51089663d8a63036d7646dc45e3ba7edf558c896791e885908bec2da7cedcfc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3b8d6e551edcdbeab96eefc8925f62174362f6e60a90d67f586fb567777dafe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff90988678bcb6d3060f2014ee80e09c58159b0187cb2754dd0f6d57085f031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d3c50ea51b0d502def75b56cd9d3e34061ed845e3f5bd7bb761f9f3fb3ecbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93730f1e6df0e1f8824cd272ca484b2ad12755e504bbcc43d10503a0343fafce"
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
