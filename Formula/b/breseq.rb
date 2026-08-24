class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/releases/download/v0.40.2/breseq-0.40.2-Source.tar.gz"
  sha256 "48983208a12b094022203ffcebb83f247fdebf13e82eacce072d271e227a41e5"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55c917e2b31851435889dab41c77d179725e315f3bc08f47e83c3db9223ebef1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34427cfc91cb99f96eff833928e6b99ca7905a3b06cbab32045e01ee82230e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463797f0a600385f50fd16a9d7c07be58976c3d72e35c635859d2231c96dc68a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3f85cef0ef0ceb80f32e6365fe0c84357c2c35a7598729e2d5476dfc0da3ef"
    sha256 cellar: :any,                 arm64_linux:   "55583e338a76372cd2df9672da425894060453e187ffd07054555e3cbd23998d"
    sha256 cellar: :any,                 x86_64_linux:  "282be82d60584b68970046a1d4547045aa2fec58bc81d557065864ad61661e21"
  end

  head do
    url "https://github.com/barricklab/breseq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bowtie2"
  depends_on "r"

  on_linux do
    depends_on "zlib-ng-compat"

    # Backport of https://github.com/samtools/htslib/commit/515f6df8ff7dab6c80d0e7aede6e60826ef5374
    # Currently not possible to easily unbundle htslib: https://github.com/barricklab/breseq/issues/399
    patch do
      file "Patches/breseq/zlib-ng.patch"
    end
  end

  def install
    system "./bootstrap.sh" if build.head?
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
