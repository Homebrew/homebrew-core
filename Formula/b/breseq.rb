class Breseq < Formula
  desc "Computational pipeline for finding mutations in short-read DNA resequencing data"
  homepage "https://barricklab.org/breseq"
  url "https://github.com/barricklab/breseq/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "5aa1bd9af71899e1358cfb9b8440c16cc908f185d9178a401a5a4d3f0c7ee861"
  license all_of: ["GPL-2.0-or-later", "MIT", "BSD-3-Clause"]
  head "https://github.com/barricklab/breseq.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9033acd95cad3f4b965f8baeacf9633bda0320067c79637a1322fe37673356c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22120bae403eb392bec70333093e7176e565853bf5108b51ed37b82a8b39d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d0b6591968d4b5747cf81d8f377560da5e8b2633d401d5e60f36e954655e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "251cb721ac1cedfb266a35557af31efc3964d9265c302c21186173c4089c5a3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f071fdaf4fb3b7b454b94674075cabe7bed6bbc630b5e3979971f62a35de4401"
    sha256 cellar: :any_skip_relocation, ventura:       "a7c5e18cc7968fd3e50450807eb1d84d2e1074b920e5a89011033c017621d248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "987988b2b8ade6641d0559570e3bb0b42dc96ab16e89d0a8fe6de973ae5f4ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecf53100efc095e8c48e3be539d2d40d12f285983ba02d64333326b3acc4040"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bowtie2"
  depends_on "r"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
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
