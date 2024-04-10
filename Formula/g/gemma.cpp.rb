class GemmaCpp < Formula
  desc "Lightweight, standalone C++ inference engine for Google's Gemma models"
  homepage "https://github.com/google/gemma.cpp"
  url "https://github.com/google/gemma.cpp/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "3dff2b979db96b57c960cde3367454194c3ef8273e144b830e8c8f9d91967b3c"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
    system "cmake", "--preset", "make", *std_cmake_args
    system "cmake", "--build", "--preset", "make"
    bin.install "build/gemma"
    lib.install "build/libgemma.a"
  end

  test do
    assert_match "Example Usage", shell_output("#{bin}/gemma --help 2>&1")
  end
end
