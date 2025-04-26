class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.3.tar.gz"
  sha256 "de1be65d34176e4776bfb4273e8227e2dee625e9e18886409443face142ca050"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae615d48110ef42c7f35949c976c02fd43f83010767f014da5b9bed435d15454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73738aa33bd384123cbfa7e141ea80dacd8cf4effb57a093f0e01a87ae88171f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb3738259c0394fb0bd67940bb8b7bfc9e82c92a8ed03728c2c68c20f91ed683"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c20cc4f91c1ca66afa1b6d06cd187954ba84e39fcae9549f59a7507eb12734"
    sha256 cellar: :any_skip_relocation, ventura:       "4635698fdb520241428be1da79308cbfc1d51f11fc7031035bb5d9c2c713df51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd633d3c5fa34da59124d221715171a9f33e790bd2deaf7acf7a0904bcad5ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3858cde0019eddcf92a58ffe1b70dd49da6df4cc9d58f97a8d38f35f5385b63a"
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
