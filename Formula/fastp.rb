class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "185bd58732e57474fa08aae90e154fbc05f3e437ee2b434386dd2266d60d8ef6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 monterey:     "a25a7b96a04b70f8bd042cbf38ca9d4e5bbb1fbc0bbb0be17c9069be3d518c47"
    sha256 cellar: :any,                 big_sur:      "db588e8e3e6c9cb627ace623b0c88118077909b48ee187107aeef9f7ab33c2e3"
    sha256 cellar: :any,                 catalina:     "c037b7e75a95093f79f6cf5efc4f99c712d301e246d06854dcf3a972edc5b3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1223647717070ef6ed0878ce3069230465d8cfb368d11a5cf3339a1c0d4382b"
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
