class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.7.0/libchewing-0.7.0.tar.zst"
  sha256 "87289bc759d04bfebad92d395d4f63e54f584f3e805731588edaa0c9a8bb6cce"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_sonoma:   "b823ea11cbf4a566589839dcd06d646f37ea70672741ef94ca8b524bc44d0915"
    sha256 arm64_ventura:  "89e205c9987821344bbfa80709794caf7f8038dc3558cc5d7cd0c1c4b913b9da"
    sha256 arm64_monterey: "3c7520eaa8ba24cc205b5b2bd519afdc54fbbc825d157c6fd0a8a0c810cd9904"
    sha256 sonoma:         "41e45e4e0d3597559653498da4161d9ad31174e54476cf5fdb569f756aba29d1"
    sha256 ventura:        "3b522a3319d72718c79952e3f7ea49a5a77f3bd988f008e53870d1f4750639e6"
    sha256 monterey:       "072906a69c35dd23d14527ec7668ca9f09621ca70936b6aa1f171a2303a3ce87"
    sha256 x86_64_linux:   "66eadfdcdb7667c3ec22feaafde96d028baed046a21899de56c7789b069a1632"
  end

  depends_on "cmake" => :build
  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <chewing/chewing.h>
      int main()
      {
          ChewingContext *ctx = chewing_new();
          chewing_handle_Default(ctx, 'x');
          chewing_handle_Default(ctx, 'm');
          chewing_handle_Default(ctx, '4');
          chewing_handle_Default(ctx, 't');
          chewing_handle_Default(ctx, '8');
          chewing_handle_Default(ctx, '6');
          chewing_handle_Enter(ctx);
          char *buf = chewing_commit_String(ctx);
          free(buf);
          chewing_delete(ctx);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end
