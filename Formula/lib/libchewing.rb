class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.10.3/libchewing-0.10.3.tar.zst"
  sha256 "03781d811a7c687a0b69f52aa30cbe6767f92a3cec61b57e461cf021245d6651"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3651a3670c1805988dd3a66b2e1f685256f8373c23496f54b9da5edcd43bfc1"
    sha256 cellar: :any,                 arm64_sequoia: "ce7436adc6b0fd817bdc95c7cb78ae6b2c300cd72302537bfc90b07cb88a44ea"
    sha256 cellar: :any,                 arm64_sonoma:  "31ade48e25e4ee49d29746193c8d21d17f296f7b69858f88d9044c154f236fe6"
    sha256 cellar: :any,                 arm64_ventura: "0866cec5ffbca86fd920c6bed163b60bb2e6cf5bf1c37e7bf48920f48d4fe817"
    sha256 cellar: :any,                 sonoma:        "28356f6c63019249646a3569ac545d943c6e167087d48835297d516311fb8a10"
    sha256 cellar: :any,                 ventura:       "5a629f88a8d948134986c209698f4bb84f97dbe3ab991643b0961d885bf97907"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "179243d02967893c3d4f321cc896f9c61d0ef06c263a58b29efac843ab6d1a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea21aaee4a6f5faa94c7653b355172f15167c08c20ddde121ee13f6f2b8986a"
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
