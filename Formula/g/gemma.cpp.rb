class GemmaCpp < Formula
  desc "Lightweight, standalone C++ inference engine for Google's Gemma models"
  homepage "https://github.com/google/gemma.cpp"
  url "https://github.com/google/gemma.cpp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "edc0529563114befcda414f0ae2ca0690b408e661ccfc3b61af360de53c00c4e"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "sentencepiece"

  def install
    system "cmake", "--preset", "make", *std_cmake_args, "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"
    system "cmake", "--build", "--preset", "make"
    bin.install "build/gemma"
    lib.install "build/libgemma.a"
  end

  test do
    assert_match "Example Usage", shell_output("#{bin}/gemma --help 2>&1")
  end
end
