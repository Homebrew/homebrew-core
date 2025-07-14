class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.4.tar.gz"
  sha256 "66ef870eb20aba9287918c597f5237b7a1d0e448a602f34cbe8c4d90ceb0611f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4fc55c00816c1e84aadd5db1443cb1a618bf56a09c94f0ab2fc6f428b0513b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24147cd43413b60f3a5efa95568b26274260e6d865a13ad71acbf932e74a5ff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "574bfd7a67e09bfa6b0aec0deadbb76578d03a19318b315879cfc15759877976"
    sha256 cellar: :any_skip_relocation, sonoma:        "390d0785d7446717e024dcb06e14371d7a5444ab6d66c71c55b77ab4683d0a0a"
    sha256 cellar: :any_skip_relocation, ventura:       "3c8cb90d3e81f4d26c6c82997645756bb22611f8c987a4c67657253132ceaf1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ddb75dad92f60f28280733a0218ea65054c947ec8de45d1efe9ff0fba3d2b14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab79c8587434f9d5285dd84063aa471b7da207cd78fa7976d858b875801224e"
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
