class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.9/libmapper-2.4.9.tar.gz"
  sha256 "315185b4923e6a6b0fd7b484f81917bc3e7d6361cd44f8e112f734bcfb5af59e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "165e054bcb7de8bc4d8af67224989dffda03d003272d2c104ddc63e17e021578"
    sha256 cellar: :any,                 arm64_ventura:  "b647984a373f82f5865afc97bd66b3777b7a4fc8d34cd0ea6e72572e0d704c8b"
    sha256 cellar: :any,                 arm64_monterey: "105b5ca0a00fc05e17d31fd8044f590df7f9b6aabbb1e80f45f723a9335332bf"
    sha256 cellar: :any,                 sonoma:         "4752c67cf956000d786522353cbf0d51856fb9302c25bcb512f0f425df5a7f1f"
    sha256 cellar: :any,                 ventura:        "acef52dc47ceefa462fe013b77071d9b49394b8613bb65538c860b505c5fa236"
    sha256 cellar: :any,                 monterey:       "41f0e09496c5a318c4dbaf8a5c5c9cc4a432a3e32104b00cb744b652d1267804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17822a27b6232e4dde431d47aed20dcb445eb69d7fecdedf7733755e9d7c8c9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
