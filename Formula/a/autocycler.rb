class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ca5690492ade7d65610c1a53eb0d982cfedf80554e3650be4b91b3c3f6cb2ab5"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f88e7be782456a4afe56de6af640c7b21597de0ffb12122203300d252b06859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c89c7d448c70d168f7d40482c63bdc295ff504d882f0f5ec88fd60e6c96a1938"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c81aecc789b9dbd580d30613b46a9ba3cde61789667fe9f217871efaa5b32226"
    sha256 cellar: :any_skip_relocation, sonoma:        "dddfbf8092e09bf5db2859c053c35df262d3374f54187d2240639b82ffef4854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c03e97faa22204998dd3b414102210ae679589df8f53ffdecbfc9e891f174a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a556368d23d7a0d0efde022250d290533d7482333dc1117b855c5a1446703b2"
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
