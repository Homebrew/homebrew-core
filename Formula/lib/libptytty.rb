class Libptytty < Formula
  desc "Library for OS-independent pseudo-TTY management"
  homepage "https://software.schmorp.de/pkg/libptytty.html"
  url "http://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
  sha256 "8033ed3aadf28759660d4f11f2d7b030acf2a6890cb0f7926fb0cfa6739d31f7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://dist.schmorp.de/libptytty/"
    regex(/href=.*?libptytty[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a8043eb470230c18db586ab547552e89aa343c13f3d101df7a8ddfb8ef2cd2f"
    sha256 cellar: :any,                 arm64_sequoia: "e04e49991b1e9e2df45463c865a99ba056d15bb854b30342955741b4be83bfae"
    sha256 cellar: :any,                 arm64_sonoma:  "bc58487292ee8f7250be2ef35f6128e148038a29129bc6d69519ddee93afa865"
    sha256 cellar: :any,                 sonoma:        "6d499c4ab02c6f3a3c2d43a1f5e50a937e8284f7fc89f856d693c05c023245cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3680a528ff52576a2d14faead10016e97ea2b8466f577c789c7e68d0b73e9dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e60096e3e90c812a12c09d5e7c35e7b5e000650b06c76df6927d3346db9d8c8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libptytty.h>

      int main(void) {
        ptytty_init();
        PTYTTY p = ptytty_create();
        if (!p || !ptytty_get(p)) return 1;
        printf("ok\\n");
        ptytty_delete(p);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lptytty", "-o", "test"
    system "./test"
  end
end
