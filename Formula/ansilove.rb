class Ansilove < Formula
  desc "ANSi / ASCII art to PNG converter in C"
  homepage "https://www.ansilove.org/"
  url "https://github.com/ansilove/ansilove/archive/3.0.8.tar.gz"
  sha256 "655472d31a9ec5a5ba29f5c15485d8647526ff8b0c9968d71f4267a9aa9bb544"

  depends_on "cmake" => :build
  depends_on "gd"

  def install
    system "cmake", "."
    system "make"
    prefix.install "examples/43-nslv1.ans"
    bin.install "ansilove"
  end

  test do
    system bin/"ansilove", "-o", testpath/"43-nslv1.ans.png", prefix/"43-nslv1.ans"
    assert_predicate testpath/"43-nslv1.ans.png", :exist?
  end
end
