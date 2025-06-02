class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.3.2.tar.gz"
  sha256 "39612423f6afe025fbd24baeaee2f5d61399ae85b186118bfdd609ca7f85b157"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e344f91aa025a43bb4dfb6ef80427a6b478a9a28f6331dace1ebb4b5d246c132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5598c73083fb8ff691d02dc8ee4804d3a54c504940cd9dfc8e30352f05bf4814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cbb13a489ddeacfab5fcae06883d3e2a72fe744ef542343ecc80b23085d31c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d63a966cbc3cdd8dcc03fefb6d49359479ac958db7db535b6f5113cf9e6ddee0"
    sha256 cellar: :any_skip_relocation, ventura:       "cfc9589da9661c562130bbc27af11d4ee9f55c8add4df376e0c4ab565e569d84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4287878ae4f311ce7a610a9be14160d79051e77276318f4e9702a06b0b40bcc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5e61604b9294ec1db85479d8620b3ab5bd042db434ea6e59ab029857468374"
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
