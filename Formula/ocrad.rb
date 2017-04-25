class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.26.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.26.tar.lz"
  sha256 "c383d37869baa0990d38d38836d4d567e9e2862aa0cd704868b62dafeac18e3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "219b9bf172b5f7379c849a8e55b04dabd74f054564fdaec2fb40502f7e996967" => :sierra
    sha256 "eb1f66d4cfb2c2c6768c89053fca5fc762c12b401b745cbbd1e6faad3ae25dcf" => :el_capitan
    sha256 "fb3e7e6ab86d242c309a1bb2eaa83451b6fa7369a63222b8025de70a3dbb8615" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
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
