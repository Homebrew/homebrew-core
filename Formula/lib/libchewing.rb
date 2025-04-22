class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.9.1/libchewing-0.9.1.tar.zst"
  sha256 "e98b76c306552148b7d85f0e596860751d9eef4bc8f2dfc053177b14f421c31f"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32135dee630c01d5a8d9a4e9bbaaa2d162d1487b422a71b7c9df375c95d54f5f"
    sha256 cellar: :any,                 arm64_sonoma:  "dda2fc0363058909c7de62a6cfdd59db89f30c6b6a6bf291da227d8beb045b7d"
    sha256 cellar: :any,                 arm64_ventura: "2698f929ef06c474f8f08f5729a6a923c89aef36b572163f353360158188f51d"
    sha256 cellar: :any,                 sonoma:        "a8bb15dfebb22f402c3bd8182b90324c273f363474c9d7ebc170e1c672e800a8"
    sha256 cellar: :any,                 ventura:       "99d2a65e3971de39db1e15f8c63c8b2b944cc25f762c903a6f161fae2d15c33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "608ffd3001265904a295d4b66d02764cbf5b63be4b8fb3e5eaa477f3ae8bfa87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d104abaa34a16aeb177b1c644b01bf8480b372405c3ca4d02ff90b9aad661196"
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
