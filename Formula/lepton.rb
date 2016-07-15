class Lepton < Formula
  desc "Tool and file format for losslessly compressing JPEGs"
  homepage "https://github.com/dropbox/lepton"
  url "https://github.com/dropbox/lepton/archive/1.2.1.tar.gz"
  sha256 "c4612dbbc88527be2e27fddf53aadf1bfc117e744db67e373ef8940449cdec97"
  head "https://github.com/dropbox/lepton.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.jpg"), "test.jpg"
    system "#{bin}/lepton", "test.jpg", "compressed.lep"
    system "#{bin}/lepton", "compressed.lep", "test_restored.jpg"
    cmp "test.jpg", "test_restored.jpg"
  end
end
