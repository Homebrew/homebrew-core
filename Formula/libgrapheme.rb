class Libgrapheme < Formula
  desc "Unicode string library"
  homepage "https://libs.suckless.org/libgrapheme/"
  url "https://dl.suckless.org/libgrapheme/libgrapheme-2.0.2.tar.gz"
  sha256 "a68bbddde76bd55ba5d64116ce5e42a13df045c81c0852de9ab60896aa143125"
  license "ISC"
  head "git://git.suckless.org/libgrapheme/", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "971fab94ac4bca569f0656596168b05847d4e25b566868e4c9ac3965ed336755"
    sha256 cellar: :any,                 arm64_monterey: "f2e9d7e0dbed9091c6ff0feb79e94ce68f73c6a83a1774efd75c3d0e76c7fbb8"
    sha256 cellar: :any,                 arm64_big_sur:  "b4ad8de03ed698baa6d540d58aa96ccb7b0f666fb357acbf55a5c75e50f9d818"
    sha256 cellar: :any,                 ventura:        "4d09c7de0e3ddaea6266896b3a0da7349701f032ae9b4e85cad29bb0f1bb2575"
    sha256 cellar: :any,                 monterey:       "14ae921b0f9c017dd446d9b05ef6d7f5ef7b1f3b30d9c3151ff64bbc9864624f"
    sha256 cellar: :any,                 big_sur:        "3a840b6287ec37255d069209beb8f49cd9634e7640ed1b4bb1b63a7f5e79fe79"
    sha256 cellar: :any,                 catalina:       "32cdbccf13da47774ca9aadd3826710c97c8bc5b9ff5cfdc8b809dd0f90ef9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a6a771715b993b79da30c2f17553198b49ba71cb5ee5d9a07ea51c0199280b"
  end

  def install
    system "./configure"
    system "make", "PREFIX=#{prefix}", "LDCONFIG=", "install"
  end

  test do
    (testpath/"example.c").write <<~EOS
      #include <grapheme.h>

      int
      main(void)
      {
        return (grapheme_next_word_break_utf8("Hello World!", SIZE_MAX) != 5);
      }
    EOS
    system ENV.cc, "example.c", "-I#{include}", "-L#{lib}", "-lgrapheme", "-o", "example"
    system "./example"
  end
end
