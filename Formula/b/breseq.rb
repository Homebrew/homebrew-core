class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "69892a3b49e60ea8c50f70115ee983531744dbfa4434c55ee4df490051846b18"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]
  head "https://github.com/barricklab/breseq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dad7c2a01f9d0c772f9fc04e2ea480fea88ec69d219c4568d06a012a49118ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831dd94986ca8cfab50490597a38cf2d09f7802003f9fcc6e622bbc076fbcb1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6898ac03f6c83eef4f532f79bcd8b3e8f209e28d43d7814303052f3669a25e"
    sha256 cellar: :any_skip_relocation, sonoma:        "49966901cd1ec0b5107a48744997bbbe782e45867ace6030ef0c3f678eb12227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "380d45d154aed1505c0bb4a5dcf6bd771aaa00cf2923e5cedf9fa2dc7db53803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8f11eabe07074878684abe6beaecf6468c1f7a5cdadbc0539ff1a9fe6cc6e90"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bowtie2"
  depends_on "r"

  on_linux do
    depends_on "zlib-ng-compat"

    # Backport of https://github.com/samtools/htslib/commit/515f6df8ff7dab6c80d0e7aede6e60826ef5374
    # Currently not possible to easily unbundle htslib: https://github.com/barricklab/breseq/issues/399
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/acbb0d0473a8bbb75ea7fbb471457a2127ef2c2d/Patches/breseq/zlib-ng.patch"
      sha256 "a15fd02db51bebb26cfa96c642d76959887cbf200edeb3a92b354bc00f269a5a"
    end
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-test-gbk" do
      url "https://raw.githubusercontent.com/barricklab/breseq/refs/tags/v0.39.0/tests/data/REL606/REL606.fragment.gbk"
      sha256 "0e6edf3df46da73db9d07622316e0b9617e7a95faf87589bb0a7bc2393e2d92e"
    end

    resource "homebrew-test-fastq" do
      url "https://raw.githubusercontent.com/barricklab/breseq/refs/tags/v0.39.0/tests/data/REL606/REL606.fragment.2.fastq"
      sha256 "79775ab79421d43b41087f256f99f38681af5421d1303b86e6e92a471edbb0fb"
    end

    testpath.install resource("homebrew-test-gbk")
    testpath.install resource("homebrew-test-fastq")

    assert_match version.to_s, shell_output("#{bin}/breseq --version")
    system bin/"breseq", "-r", "REL606.fragment.gbk", "REL606.fragment.2.fastq"
    assert_path_exists "output"
  end
end
