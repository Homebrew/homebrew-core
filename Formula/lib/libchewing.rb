class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.12.0/libchewing-0.12.0.tar.zst"
  sha256 "6a7fae4aaa6e6ce2bd9f70f0016c553585ed5aca1e086476749a03ac5c3f4cb0"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "132a00dc2d430eee97da513f027bbf7538c741a5a906213f24eae75523325dcd"
    sha256 cellar: :any,                 arm64_sequoia: "93393ae059645d40d480d9ffd46fc24bac18311dcc8b7dda2c9ad60e18d242ac"
    sha256 cellar: :any,                 arm64_sonoma:  "2857339bc640c248c24b7e89470ffff99c75c5b22f3219b5c8a3d8a55c817379"
    sha256 cellar: :any,                 sonoma:        "872ccd2c82e688df4cf89e5b6a59556941131caa45f0bcb3c865847c07994115"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d54639766d9098ea291fdf8f35772c3c69155c64031155e4bf3a643646702d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc33705591f2168afb5d547d1d3eca3657a1ca57d406e0c7e5fb3746b7cb0e8e"
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
