class Mbw < Formula
  desc "Memory Bandwidth Benchmark"
  homepage "https://github.com/Willian-Zhang/mbw/"
  url "https://github.com/Willian-Zhang/mbw/archive/refs/tags/1.4.1.tar.gz"
  sha256 "b164aeca13e351acdec89ea5fbd3e406a62686f9a4514aba6c3ae4d75aaf94d4"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pipe_output("#{bin}/mbw", 0)
  end
end
