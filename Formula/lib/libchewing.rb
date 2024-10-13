class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.9.0/libchewing-0.9.0.tar.zst"
  sha256 "58e62cd0649ba3856ffa7c67560c1cfbcbb8713342a533f7700587b51efe84e3"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "194df88e37fb9f06e484451536179aa9e70205bb6cec478237b74a2affd4aa78"
    sha256 cellar: :any,                 arm64_sonoma:   "bf5d393311d81a3c2acf6bdf72d87077753d29f542c53098091ba735708f5e76"
    sha256 cellar: :any,                 arm64_ventura:  "a463d654e4b1a5af70ee899e1d910369c2ff351ada610c6183d6ae2059e50362"
    sha256 cellar: :any,                 arm64_monterey: "740ae10b7e160ab3d19a9408fcb43762b4dd6a21bdb8937b934018677a48a86d"
    sha256 cellar: :any,                 sonoma:         "fac5342af7b49d911c172b2cbdecb3471b7e0e5540eae52e5fced7b682d37c3f"
    sha256 cellar: :any,                 ventura:        "4d7493a2d7c3cd32403818c67febc600bc523f1b9451cebb6bc3aa79a0b0b466"
    sha256 cellar: :any,                 monterey:       "e7ac391a9bc6fd62a54986e0f04d5613003c67483b0225d0bcdb787a90c199ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd952ae97b07cd87a12b0e37368935e58933db188c108862c56620aa787adf5"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
