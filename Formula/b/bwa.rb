class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "cdff5db67652c5b805a3df08c4e813a822c65791913eccfb3cf7d528588f37bc"
  license all_of: ["GPL-3.0-or-later", "MIT"]
  head "https://github.com/lh3/bwa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc016b492675be407b846cf3e2563a31bf6a0544f638edc0428adf0d2c230daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ba4019988805cae03027361d588c146e9d66d1892e77d198f61debf7bdca55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60e7929c8f1f41208c7bfceacb5efc01f59b80e3e7f3a851649c292828c78f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f491bc38742ec5a88f4bfcdb0ec21282194431c030e07f048cde10aca954314"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe60cd80664c0121d756da12e3211b4b7aeab1ac0ea7cacc426d2b24c0e4f164"
    sha256 cellar: :any_skip_relocation, ventura:       "b82547f3bd7fa1aefccbb3951e45d7ac35697a040f4188920bfc91492fc520d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde4bc264cfe51298a5c0fcf979c9f8892371f1543d55b54680585c10f7b8383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b243ede1154f5e75c9c1af01f98be6b42be5e632d0054b3487e306b52e265eae"
  end

  uses_from_macos "zlib"

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    system "make"

    # "make install" requested 26 Dec 2017 https://github.com/lh3/bwa/issues/172
    bin.install "bwa"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system bin/"bwa", "index", "test.fasta"
    assert_path_exists testpath/"test.fasta.bwt"
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
