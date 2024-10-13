class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.12/libmapper-2.4.12.tar.gz"
  sha256 "84eaa87c609416f152747b112d7823b293af70589449e795981d6c2f3ab36cad"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ea077234bd2081203a62d8850db85b2f429f0d17d2e5ee465d60a1bdb53daf2"
    sha256 cellar: :any,                 arm64_sonoma:  "5085301bb85a200309aacdef50ce40bfcc73754b0b48af7d2e9b01b54ca75f5c"
    sha256 cellar: :any,                 arm64_ventura: "fb0dc4d510f7a4d4686b91007d513344cc41b54d3fa5a9b658fb8a13ea4e3ef5"
    sha256 cellar: :any,                 sonoma:        "7d9e7f9ce666c61467d5bfb3a2ec4d8883eb1c9582bfa0b25b3b07cd3e3de6c4"
    sha256 cellar: :any,                 ventura:       "9dc9d06fdab3767de70d2dcbf2d920356286db60176d504f0cd28c2f5d9d38c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b906b25b9ed8d6712cf8383fe4c16d20c23917fcf788a41cfc7d56f6266b6b02"
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
