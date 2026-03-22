class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5aa1bd9af71899e1358cfb9b8440c16cc908f185d9178a401a5a4d3f0c7ee861"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]
  head "https://github.com/barricklab/breseq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "def2a384df5495e166004a40f6a0ca64dc395aeb2cd733a86a8ec104ae313af4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3f2c4e800dff841d54930aab30ef679f25baecbe55c6c4e78c4bc5c162ddd2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85ee61e283d29958259d3e008e1a3b9729f4e1f0223a6a155ac4bcd1128c916f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95b4eb870ce333f0c30b8af90acd189d2f4183ee062cedb7d099f366d3f3cbf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b67dff0c121eee03cd1538f700a4329e82d2b9e5c6295a8a5b7d209e8264dcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ea055967954551fdf4b990211176d6f4ba5fb468d45eeb82a3e1265212f332"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bowtie2"
  depends_on "r"

  on_linux do
    depends_on "zlib-ng-compat"

    # Backport of https://github.com/samtools/htslib/commit/515f6df8f7f7dab6c80d0e7aede6e60826ef5374
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
