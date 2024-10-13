class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "4fad6db156e769d46071add8a778a13a5cb5186bc1e1a5f9b1ffd499d84d72b5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "71fe30d7e3a8c3dc5db10da66d8972a7387e357ae9f86b5e6bbb04e22e7e72a6"
    sha256 cellar: :any,                 arm64_sonoma:   "6bace081bf270bce7cb74c99ae3a6e6969ed390f5eb1eecabd2c4d25b17e0ad6"
    sha256 cellar: :any,                 arm64_ventura:  "e4af98afd3553bc385ecf1c723f21f15932f9bef5819f340e593a5782817ff45"
    sha256 cellar: :any,                 arm64_monterey: "0d91c6bf282d1ec7fa7b91a15e0daa6387788b5b0ee816334e3ae521daa7013f"
    sha256 cellar: :any,                 sonoma:         "064eb9df00c4d8504168b9de2c0316836f98d14623ec830465dfecd2853ca0a3"
    sha256 cellar: :any,                 ventura:        "c0e5740eb70059751d80e74eb92170af20b9e547b5183eddf47b61ec6a40a424"
    sha256 cellar: :any,                 monterey:       "8be736b29ff350632aa615978605a8c023b4d9b6aeb951452a3525d3cef17a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e51bb52dfedf81cc82c30b4a64364a4414de0dc9960af325c064c64529ee44a"
  end

  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_predicate testpath/"out.fq", :exist?
  end
end
