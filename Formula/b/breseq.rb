class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "1728515bea394dd0876ca5dedc78c724b836c370bb201bda1d585cb6fa058a52"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]
  head "https://github.com/barricklab/breseq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3d40182dbf71cddc316bd1349d70fa7c2aa5a262324bba93a0090e6225bfc70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1654a72c4ba499ff47f755911bc21cfa86268b5d825c9099dcf567b1ccad3afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247f05cb7334de6abb903f2e9bef85d086c9c11f9e4138b8f4d9fbbdbc3ccf54"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8b18f44c48e8610c9ba5ab84e6a8954649b2fc8883409fe32088a8f5980f7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c49d20b3be67929b921d1174fb5d2702f786ca6d6563ec63af7110b9a2f9a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61129433de0f2142a2b0c6c8ba4bb7282f2c5da0220d097976c15016f8eb1cce"
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
    # Remove hardcoded static zlib option
    inreplace "configure.ac", "with_static_libz=\"$WITH_STATIC_LIBZ\"", ""

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
