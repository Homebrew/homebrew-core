class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.27.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.27.tar.lz"
  sha256 "a9bfe67e9a040907aff5640dca56392476b6a89e48e37dc94ba846c5b6733b36"

  bottle do
    cellar :any_skip_relocation
    sha256 "6533cd452587714531d20b4aa74ea7fc1e323ff893c8a7c9729655ede1ec9df7" => :catalina
    sha256 "3d1c85bb36faedf5ab12f78e8c3511dcc4164561ba8bc09924b48f6aa3fa0b37" => :mojave
    sha256 "ba9b30eeabc11634502e30fd9a730d5727668550f9708d46fbefc03bcb3917de" => :high_sierra
    sha256 "903ce6530395c0973418020561ddd60da739f3a36e865500776922e18975460b" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
