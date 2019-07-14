class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.27.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.27.tar.lz"
  sha256 "a9bfe67e9a040907aff5640dca56392476b6a89e48e37dc94ba846c5b6733b36"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec28597359fb7399667a71919805981b06fed05571ecebcdd982a1b0de61b0cf" => :mojave
    sha256 "9f6a1c40b39e78418342c54ca981648d0b2fe8db03c1fb81bf44aff3225e1dd9" => :high_sierra
    sha256 "219b9bf172b5f7379c849a8e55b04dabd74f054564fdaec2fb40502f7e996967" => :sierra
    sha256 "eb1f66d4cfb2c2c6768c89053fca5fc762c12b401b745cbbd1e6faad3ae25dcf" => :el_capitan
    sha256 "fb3e7e6ab86d242c309a1bb2eaa83451b6fa7369a63222b8025de70a3dbb8615" => :yosemite
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
