class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.11.0/libchewing-0.11.0.tar.zst"
  sha256 "b2dc134f994db524d735c014c7ff41285ab439c3f7a437bb5f0e446a63b7220d"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed3ecdbd9b626a1416b759d92545511acd3134f1d70ccbc0e8881a11868ad2d3"
    sha256 cellar: :any,                 arm64_sequoia: "7988b3043cd55bb94ea1b044371ed2f320006df97406e6ef261f32c1150afe10"
    sha256 cellar: :any,                 arm64_sonoma:  "8214dd0b162970d155823832199d6c61d61c02b70ffaf3f0cd006f27d62c2088"
    sha256 cellar: :any,                 sonoma:        "e9662123cbf849b97198608b564ea106cc8cf52c30daec61f47a7fa5d23ce76e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94021f295b0bc602de4c7735af212f7ab5dea609b786dfd2a3de88aa068c746f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8961ede2ccf15b8dc15692704a4679367b9ce2f34af505019d1f03ce59d3fc7"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lchewing", "-o", "test"
    system "./test"
  end
end
