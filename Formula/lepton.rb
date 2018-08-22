class Lepton < Formula
  desc "Tool and file format for losslessly compressing JPEGs"
  homepage "https://github.com/dropbox/lepton"
  url "https://github.com/dropbox/lepton/archive/1.2.1.tar.gz"
  sha256 "c4612dbbc88527be2e27fddf53aadf1bfc117e744db67e373ef8940449cdec97"
  head "https://github.com/dropbox/lepton.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b3d88dced1ee91a38ba4a7ede4f21cac5e0ce2d9d5cc3b5f89775c36fbbb177" => :mojave
    sha256 "496840db331a445a5ba66475a58782a26d5a910b9d7ed8fb1aa2e0f9b98c68b9" => :high_sierra
    sha256 "6713be0e881459057b561cbfd6902d167dc9601be856b8715e9abd6ffc02b605" => :sierra
    sha256 "a6a1a47dd2f80fe66d5dfbde97b91ba93d054f6934ba2a950ede603e405e6eed" => :el_capitan
    sha256 "700264c93fab4bba78cf62ac3a77ea60099cd38399f00d6972f8093b89dd8404" => :yosemite
    sha256 "fc7f77f9ed19af975e747b8eb8e39b6187f12ed226e2b1c15553a8c0e470bdff" => :mavericks
  end

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
