class Gperf < Formula
  desc "Perfect hash function generator"
  homepage "https://www.gnu.org/software/gperf"
  url "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
  sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ecfe525a1faf4e0c24ac61a230b3d19bebcf5272c0d6375a88f18fba347357c" => :sierra
    sha256 "4add2ee04e49c8f35d381bc45c4eeef00321b29da8e8c7d4b44f57a129ef6057" => :el_capitan
    sha256 "21a4e668f9cab868567c47b0da06ba0b340a0d5b68dfd9c2f5d5fbcdd450672e" => :yosemite
  end

  keg_only :provided_until_xcode43

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "TOTAL_KEYWORDS 3",
      pipe_output("#{bin}/gperf", "homebrew\nfoobar\ntest\n")
  end
end
