class Gw < Formula
  desc "GW is a fast browser for genomic sequencing data (.bam/.cram format), used directly from the terminal. GW also allows you to view and annotate variants from vcf/bcf files."
  homepage "https://github.com/kcleal/gw"
  version "v0.3.1"
  url "https://github.com/kcleal/gw/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "b479e19c2fed0704a652c0fcbd653517ce01ac429ec7753c95a583c35a733012"
  license "MIT"
  depends_on "htslib"
  depends_on "glfw"
  depends_on "wget"

  def install
    system "make prep"
    system "sed -i.bak 's/lglfw/lglfw3/g' Makefile && make"
    bin.install "gw"
  end

  test do
    system "gw --version"
  end
end
