class Libchewing < Formula
  desc "Intelligent phonetic input method library"
  homepage "https://chewing.im/"
  url "https://github.com/chewing/libchewing/releases/download/v0.6.0/libchewing-0.6.0.tar.xz"
  sha256 "c2913bed55b7fdb25942b6a5832c254bc9bcb9c365d3cafa0a569b4b7cbd8f00"
  license "LGPL-2.1-only"

  bottle do
    sha256 arm64_sonoma:   "f6b0bae26a972636b58d05cd8d38e1f190bbb9b8451697b71250d1b8565d7755"
    sha256 arm64_ventura:  "2e81a74c69dd6d45f338c834307e462b2e3eadae969ee38a4808feb81ac82cfe"
    sha256 arm64_monterey: "04d6bc7b63800ffdcc2eea940241e5ef2159dc36eab0f65d75584fef6a7e1a41"
    sha256 sonoma:         "a51840ab89e99407f22784ab4b5d5a9997e78e65b060b1de12cdfebfe629ea86"
    sha256 ventura:        "4bc98f0aa284a4086f18c65a24a566969d021f9414fc2bb8d722b8749a11ab9a"
    sha256 monterey:       "46d704071c778e0d718a37ac0d0ae25de49025e7679e02b17358155efce877a7"
    sha256 x86_64_linux:   "b3c77db3b0e9db76fb7341cb8d0fd30959d251e69da1ac6504eb293733076b3d"
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
