class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.6.tar.gz"
  sha256 "485669e8f9a6c74e528947d274df705f13caaf276d460d0f037b8dbc0c9c0a99"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "fb8828f5f605378c1e10ebb8b5b997159c4a49f1a29256b0807a307df9d4ac24" => :big_sur
    sha256 "93a49e499f6cca69e9bc62e64e3bbf51fd9c8ab3c51e6ba15b6a1ab3feb4d2e8" => :catalina
    sha256 "7070ec9a601335d1844820e722c346b9d7003ce80af4450f631521a023c291bc" => :mojave
    sha256 "46185fc5980d6e411f4073ea330735498d918bb25dc65cb90909bb41749e8756" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
