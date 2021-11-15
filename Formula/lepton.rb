class Lepton < Formula
  desc "Tool and file format for losslessly compressing JPEGs"
  homepage "https://github.com/dropbox/lepton"
  url "https://github.com/dropbox/lepton/archive/1.2.1.tar.gz"
  sha256 "c4612dbbc88527be2e27fddf53aadf1bfc117e744db67e373ef8940449cdec97"
  license "Apache-2.0"
  head "https://github.com/dropbox/lepton.git"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "76ad15c6eea9edaf46a6dd3cad91d20c74c234001c1af3a46a9f7bbf4f44ff95"
    sha256 cellar: :any_skip_relocation, big_sur:      "588d9fa1928b1a90e9ff6e49b4558bc1e5e228b50cce311614e2f1ba65190b92"
    sha256 cellar: :any_skip_relocation, catalina:     "61424564a043a4a02ac9beab50a3c57dc454d4c301e536cf17d1457aac82bba9"
    sha256 cellar: :any_skip_relocation, mojave:       "5b3d88dced1ee91a38ba4a7ede4f21cac5e0ce2d9d5cc3b5f89775c36fbbb177"
    sha256 cellar: :any_skip_relocation, high_sierra:  "496840db331a445a5ba66475a58782a26d5a910b9d7ed8fb1aa2e0f9b98c68b9"
    sha256 cellar: :any_skip_relocation, sierra:       "6713be0e881459057b561cbfd6902d167dc9601be856b8715e9abd6ffc02b605"
    sha256 cellar: :any_skip_relocation, el_capitan:   "a6a1a47dd2f80fe66d5dfbde97b91ba93d054f6934ba2a950ede603e405e6eed"
    sha256 cellar: :any_skip_relocation, yosemite:     "700264c93fab4bba78cf62ac3a77ea60099cd38399f00d6972f8093b89dd8404"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0fdd05b0bfb892d9f768134cc9c929ae9544137b8ac75a875f06d6f83d15607d"
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
