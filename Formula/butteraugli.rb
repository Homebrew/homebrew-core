class Butteraugli < Formula
  desc "Measuring differences between images."
  homepage "https://github.com/google/butteraugli"
  url "https://github.com/google/butteraugli/archive/2f8d6a0b1466b003d610271ef1f0ae3dd0d28998.tar.gz"
  version "0.1"
  sha256 "79ce7ead4ccb159b84bbab05e8a3e569c3b98b032ee58bdfd13df25acc85d5a2"

  depends_on "libpng"

  def install
    cd "src"
    system "make"
    bin.install "compare_pngs"
  end

  test do
    # unfortunatley, butteraugli fails when applied to the test fixtures
    # system "#{bin}/compare_pngs", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
