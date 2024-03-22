class GemmaCpp < Formula
  desc "Lightweight, standalone C++ inference engine for Google's Gemma models"
  homepage "https://github.com/google/gemma.cpp"
  url "https://github.com/google/gemma.cpp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "218280867d6f5256d3e3a9a34852e5752acd284538a8e7edaa6b382319e67c5c"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "sentencepiece"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    cd "build" do
      system "make", "gemma", "libgemma"
      bin.install "gemma"
      lib.install "libgemma.a"
    end
  end

  test do
    system "#{bin}/gemma"
  end
end
