class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "194788087f7b9a77c0114aa481b2ef21439f6abab72488c83917302e8d0e7870"
  license all_of: ["GPL-3.0-or-later", "MIT"]
  head "https://github.com/lh3/bwa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f6b87e89a46108e9c8f92ea8ceaf747ba0e8b759c685c0a0f9379e3f9733768"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab4ac87cfd87c58980d86cd85ddbb254e8b3e283148f3589efe7e9f4fa58ac7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a187c420db866dc844ea6f712656b4e4c86bc3640289ac63e71c3b2cbb90a4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "55d0c3fa4de82095c0421c6962a0720c5830fa9402c257342837a0e473c395ac"
    sha256 cellar: :any_skip_relocation, ventura:        "2c4ee46e300f7fb8b39728c4569697319641f90cfd87391cafc14a65c7dcbeb6"
    sha256 cellar: :any_skip_relocation, monterey:       "b035ce4068ab880f243402289cb17cf5b165b7d3eb209385bf32c31d6e1d815d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9307f2d732feb2083c8a8347a972d4c335b6815fd4c4b7813e1e913f9724049c"
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
    assert_predicate testpath/"test.fasta.bwt", :exist?
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
