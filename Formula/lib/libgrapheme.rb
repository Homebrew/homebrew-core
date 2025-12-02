class Libgrapheme < Formula
  desc "Unicode string library"
  homepage "https://libs.suckless.org/libgrapheme/"
  url "https://dl.suckless.org/libgrapheme/libgrapheme-2.0.2.tar.gz"
  sha256 "a68bbddde76bd55ba5d64116ce5e42a13df045c81c0852de9ab60896aa143125"
  license "ISC"
  head "https://git.suckless.org/libgrapheme/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/libgrapheme/"
    regex(/href=.*?libgrapheme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1a83f1b069707a62ab7144ecd7702ce69bb04c622d873f984498dbf8dd355ed6"
    sha256 cellar: :any,                 arm64_sequoia:  "15463cba352ca4de4ebd865ae7aeee520871711b7c0dca0cceebfba78dbe88c5"
    sha256 cellar: :any,                 arm64_sonoma:   "961545ff7d4e1825ee195a79d6522ba7ae226c401d72b655410d8a132933eb2e"
    sha256 cellar: :any,                 arm64_ventura:  "971fab94ac4bca569f0656596168b05847d4e25b566868e4c9ac3965ed336755"
    sha256 cellar: :any,                 arm64_monterey: "f2e9d7e0dbed9091c6ff0feb79e94ce68f73c6a83a1774efd75c3d0e76c7fbb8"
    sha256 cellar: :any,                 arm64_big_sur:  "b4ad8de03ed698baa6d540d58aa96ccb7b0f666fb357acbf55a5c75e50f9d818"
    sha256 cellar: :any,                 sonoma:         "85e08a9ae4f0d7a6254abc0174d0f82c8d57c2f787719047d2109a015144a52a"
    sha256 cellar: :any,                 ventura:        "4d09c7de0e3ddaea6266896b3a0da7349701f032ae9b4e85cad29bb0f1bb2575"
    sha256 cellar: :any,                 monterey:       "14ae921b0f9c017dd446d9b05ef6d7f5ef7b1f3b30d9c3151ff64bbc9864624f"
    sha256 cellar: :any,                 big_sur:        "3a840b6287ec37255d069209beb8f49cd9634e7640ed1b4bb1b63a7f5e79fe79"
    sha256 cellar: :any,                 catalina:       "32cdbccf13da47774ca9aadd3826710c97c8bc5b9ff5cfdc8b809dd0f90ef9f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5ea309461d84ca854a54880efc24a348a2bf76769c9512ef8167574f8a280b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a6a771715b993b79da30c2f17553198b49ba71cb5ee5d9a07ea51c0199280b"
  end

  def install
    system "./configure"
    system "make", "PREFIX=#{prefix}", "LDCONFIG=", "install"
  end

  test do
    (testpath/"example.c").write <<~C
      #include <grapheme.h>

      int
      main(void)
      {
        return (grapheme_next_word_break_utf8("Hello World!", SIZE_MAX) != 5);
      }
    C
    system ENV.cc, "example.c", "-I#{include}", "-L#{lib}", "-lgrapheme", "-o", "example"
    system "./example"
  end
end
