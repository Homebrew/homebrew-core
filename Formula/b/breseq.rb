class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/releases/download/v0.40.3/breseq-0.40.3-Source.tar.gz"
  sha256 "547769032d69af08a155985844ce314081368792cd48d7747631b332a37d291d"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c462c15ee597fc4e12dc374c635bb7795e0e043d63051b8bc2f93678e6cb39da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "846c5cd36fb225f17a4f2cf2ce0e1d2036d59750fc9bb32dac6924c96a31a70d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd605a578b171d8b5e11cee880724ce766782cdb97b30e9ab7fa9124925f4fee"
    sha256 cellar: :any,                 arm64_linux:       "701f023b6d791bf5169a00a6193965ea1b4045927181ccf912975e48504340ff"
    sha256 cellar: :any,                 x86_64_linux:      "eee49502a6c17d26edf2ed5e8226b9df3530deb8414293c369f537acda142945"
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
