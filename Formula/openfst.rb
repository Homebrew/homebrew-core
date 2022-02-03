class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.2.tar.gz"
  sha256 "de987bf3624721c5d5ba321af95751898e4f4bb41c8a36e2d64f0627656d8b42"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6062e938b92156ce6bf247682bf18755918678333ef4abd079533a3459c950de"
    sha256 cellar: :any,                 arm64_big_sur:  "6133234e79a10929c05657d79c9f47e8e646b36cf7f023ab9dd8b3151dec7f34"
    sha256 cellar: :any,                 monterey:       "a99d0befd091c674cb054c07c0c3298ab670bf98f510d05493c9338bc56d69b1"
    sha256 cellar: :any,                 big_sur:        "d5139b2d98c091cb1d3b5215392b9c84ee94e6d51e0a2a1dad6a4ff05b9dc2c9"
    sha256 cellar: :any,                 catalina:       "7aea4b496aac30803d9cdb99f90e30ba0b44b240a822f7b9a25df963f845f57b"
    sha256 cellar: :any,                 mojave:         "1e4d6b330797e513315266073af2647d08b1e5a123d11fc165ace77cd2de43e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f7089734a90d7fabd44553bb4fc87c3be0a5b3541182bc54129b2379bf2df5"
  end

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_predicate testpath/"binary.fst", :exist?
  end
end
