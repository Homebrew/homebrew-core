class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "70efff324fc9b0a4ad70bef7984c4eb78b69b989011aa17eea4b5d75b5b9c5ff"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b84a2f46567714a7e3f29a45e62ad5c6e18c0a63e7aed57b362595b6168ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c10330c8dbcdc227872e7e929440369c90b4126b2faa775c99ca9f26fc2f688"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e38084d730edde278ecc087622d1b0ac5e7bdb58c0ab35a9f23b4b882e16390e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb2758188d32e2faf4ebfce3ebcec0a3becab5cca4d38167d18d7275d93ddbe5"
    sha256 cellar: :any_skip_relocation, ventura:       "ff5e52582afbb9933ee9e0611955cba9189093688344efc372bac14c12f778db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41df82eab0fb917af597dc822b2421da78a11a632553a092984dd31892ba4d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710aeda2a8aaaee2bd01c3ebf3de93166ba391c8fcfca7b1631c6fce48296c86"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "autocycler-demo-dataset" do
      url "https://github.com/rrwick/Autocycler/releases/download/v0.1.0/autocycler-demo-dataset.tar"
      sha256 "70a5480b4390b2629a9406aad788cb2813570827b86b37b982609e6842ba0bc9"
    end

    resource("autocycler-demo-dataset").stage testpath
    system bin/"autocycler", "subsample", "--reads", "reads.fastq.gz",
                             "--out_dir", "subsampled_reads",
                             "--genome_size", "242000"
    assert_path_exists "subsampled_reads"
  end
end
