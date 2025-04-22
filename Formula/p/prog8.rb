class Prog8 < Formula
  desc "Compiled programming language targeting the 8-bit 6502 CPU family"
  homepage "https://prog8.readthedocs.io"
  url "https://github.com/irmen/prog8/archive/refs/tags/v11.2.tar.gz"
  sha256 "2e06e38c5b83c277a1671cd5d20e02373dfb4b52f8ec0064dc21f8e272b9edb3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236ab9131d78c222312ae618875010180cbf02b157c79ee275ca9bf5960e96c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f9f42656aae27aea98090928eb01f6c94ebc632be2e2b87b81962dae463a69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e36385c5968f414e976a547f344996dee0c8c5b3c9c437bd8ad75b4d7d75925"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8ab326a823ff286fc0d5dd717e2730b6d55b4926d8d55d5a7acc8e28cc3c8d"
    sha256 cellar: :any_skip_relocation, ventura:       "8dd51e9bfe666751eff6ecde3b4d897df3de793ffc57681e8bd53a01401299cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef5e3dd49304ce46d0e838cd3c410c674cd85d309180429de1f69e30149b5333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161cbfda304f5f4294c4eb7cffbd9beeda468295ed12c65cfc5d0b44e8cc4674"
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
