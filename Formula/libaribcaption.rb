class Libaribcaption < Formula
  desc "Portable ARIB STD-B24 Caption Decoder/Renderer"
  homepage "https://github.com/xqq/libaribcaption"
  url "https://github.com/xqq/libaribcaption/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6e4ff246155524e0e90d8657148b53e1322d5197d524e7b490bbee4ffcdc66c5"
  license "MIT"
  head "https://github.com/xqq/libaribcaption.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DARIBCC_SHARED_LIBRARY=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <aribcaption/decoder.h>

      int main(int argc, char *argv[]) {
        aribcc_context_t* ctx = aribcc_context_alloc();
        if (!ctx)
          return 1;
        aribcc_context_free(ctx);
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libaribcaption").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
