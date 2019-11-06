class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf"
  url "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
  sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc18781c090c4b8b7bb7305a864eeb4e6f3f458d8daa2fff96da3bda061fa8bb" => :catalina
    sha256 "85c9bd450b0a0d7453584c343fe6770c94f8f3941aaa6f95d735f1923209b6ed" => :mojave
    sha256 "d71157cd1baddf951e91477b85b533ade99dfe97a5876bb993fe7f6e8336f780" => :high_sierra
    sha256 "3cbaa18692ac53ce98a754d46e07e89d6dddca4bef3bbb312e762abf5a30093d" => :sierra
    sha256 "27f661ef9546ff113279654e92c08bb8d8ab837f7dc8b308c1a2beeafdcebc76" => :el_capitan
    sha256 "263440c302dddec69c2140e8df2e4c00a76b76137243e712e8e8756140e0eaf5" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output("#{bin}/gperf", "homebrew\nfoobar\ntest\n")
  end
end
