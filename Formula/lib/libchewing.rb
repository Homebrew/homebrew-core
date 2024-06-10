class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.8.4/libchewing-0.8.4.tar.zst"
  sha256 "c272e85c9aff03265db08641cac25709b9faf45b4602e04ea6cb39317103b3fa"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f1a299fcae44b3ff5c4b857e7218ea8b9ec689eec261a7787efce48084a99e7"
    sha256 cellar: :any,                 arm64_ventura:  "39f8feb5a332fb7e5c5ccf7a7c34f2962ea06af11821dc2a797d6d6a9f44c6eb"
    sha256 cellar: :any,                 arm64_monterey: "c5d4c657ae42255346a6948686c6c133be6759b074fac940e666d7fe06a6ab47"
    sha256 cellar: :any,                 sonoma:         "72f4a959c958f5cc3857cc70e993130c946932fa720a45cb7fc35ec2f2eafa8a"
    sha256 cellar: :any,                 ventura:        "7fadf43898c394b03850e0135cb4bcf1e49503d624ac67107f5f5467c3be1542"
    sha256 cellar: :any,                 monterey:       "7fb74f41c2c0709f5167733b54bf7a533848b02d2d03d4c6abffe7ccdbd4557a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b1c2e758831df267ae0a6245a69a2002086bc26ce7ee30be9e5c1a9d55e1252"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # cmake build patch, https://github.com/chewing/libchewing/pull/575
  # remove in 0.9.0 release
  patch do
    url "https://github.com/chewing/libchewing/commit/b21ff8f118e6138b795da4d37026712516a12676.patch?full_index=1"
    sha256 "13d64e23d42c0549117bc2f6239cd09da03d17d2f8015a81fb1a3307aeaf708f"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_TESTING=OFF", *std_cmake_args
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
