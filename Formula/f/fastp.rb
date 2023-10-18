class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.23.4.tar.gz"
  sha256 "4fad6db156e769d46071add8a778a13a5cb5186bc1e1a5f9b1ffd499d84d72b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 sonoma:       "a54df97f0602036abf788bdbb6c7bda362337fb03767093cb0963199b3db03c9"
    sha256 cellar: :any,                 ventura:      "67d4229c08075e858a8b8a8da5b6e4e4fdf50e4542f4c799d6955de51cbc6ea9"
    sha256 cellar: :any,                 monterey:     "5e7b279df24f6065f22d52be29a19ac574781a62a57f49449ae8fd49dbaffc08"
    sha256 cellar: :any,                 big_sur:      "88284d74dc8c61010fe62cdd658c5e9d22db6ef8a7ef0c0b15509f529a153912"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0589cde1438c370799e468eead88bb2e537bc59ac390512c3b30161315162937"
  end

  depends_on arch: :x86_64 # isa-l is not supported on ARM
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
